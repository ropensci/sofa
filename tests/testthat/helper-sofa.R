library(sofa)

envvar <- function(x, default = NULL) {
  value <- Sys.getenv(x)
  if (nzchar(value)) value else default
}

`%||%` <- function(x, y) if (is.null(x)) y else x

fake_response <- function(req, body, status = 200L, headers = list()) {
  content <- charToRaw(jsonlite::toJSON(body, auto_unbox = TRUE, null = "null"))
  if (!is.null(req$disk)) {
    writeBin(content, req$disk)
    content <- req$disk
  }
  crul::HttpResponse$new(
    method = req$method,
    url = req$url$url,
    opts = req$options,
    handle = req$url$handle,
    status_code = status,
    request_headers = req$headers,
    response_headers = c(list(`content-type` = "application/json"), headers),
    response_headers_all = list(),
    modified = Sys.time(),
    times = numeric(),
    content = content,
    request = req
  )
}

fake_error <- function(req, status, error, reason) {
  fake_response(req, list(error = error, reason = reason), status)
}

fake_raw_response <- function(req, body, status = 200L, headers = list()) {
  crul::HttpResponse$new(
    method = req$method,
    url = req$url$url,
    opts = req$options,
    handle = req$url$handle,
    status_code = status,
    request_headers = req$headers,
    response_headers = headers,
    response_headers_all = list(),
    modified = Sys.time(),
    times = numeric(),
    content = body,
    request = req
  )
}

new_fake_couchdb <- function() {
  state <- new.env(parent = emptyenv())
  state$dbs <- new.env(parent = emptyenv())
  state$uuid <- 0L

  next_uuid <- function() {
    state$uuid <- state$uuid + 1L
    paste0("000000000000000000000000000000", sprintf("%02d", state$uuid))
  }
  next_rev <- function(doc = NULL) {
    generation <- if (is.null(doc) || is.null(doc$`_rev`)) 1L else {
      as.integer(sub("-.*", "", doc$`_rev`)) + 1L
    }
    paste0(generation, "-", paste(sample(c(letters, 0:9), 32, TRUE), collapse = ""))
  }
  db_exists <- function(db) exists(db, state$dbs, inherits = FALSE)
  get_db <- function(db) {
    if (!db_exists(db)) return(NULL)
    get(db, state$dbs, inherits = FALSE)
  }
  user_docs <- function(db_env) {
    ids <- sort(ls(db_env$docs, all.names = TRUE))
    ids[!startsWith(ids, "_design/")]
  }
  doc_copy <- function(doc) doc[!names(doc) %in% "_deleted"]
  save_doc <- function(db_env, id, doc) {
    old <- if (exists(id, db_env$docs, inherits = FALSE)) {
      get(id, db_env$docs, inherits = FALSE)
    } else {
      NULL
    }
    doc$`_id` <- id
    doc$`_rev` <- next_rev(old)
    assign(id, doc, db_env$docs)
    db_env$seq <- db_env$seq + 1L
    db_env$changes[[length(db_env$changes) + 1L]] <- list(
      seq = db_env$seq,
      id = id,
      changes = list(list(rev = doc$`_rev`))
    )
    doc
  }
  parse_query <- function(url) {
    query <- sub("^[^?]*\\??", "", url)
    if (!nzchar(query) || identical(query, url)) return(list())
    pairs <- strsplit(query, "&", fixed = TRUE)[[1]]
    out <- lapply(pairs, function(x) {
      value <- strsplit(x, "=", fixed = TRUE)[[1]]
      utils::URLdecode(value[2] %||% "")
    })
    stats::setNames(out, vapply(strsplit(pairs, "=", fixed = TRUE), function(x) utils::URLdecode(x[1]), ""))
  }
  parse_path <- function(url) {
    path <- sub("^https?://[^/]+", "", sub("\\?.*$", "", url))
    if (!nzchar(path)) "/" else path
  }
  parse_body <- function(req) {
    raw <- req$options$postfields
    if (is.null(raw) || !length(raw)) return(list())
    txt <- rawToChar(raw)
    Encoding(txt) <- "UTF-8"
    if (!jsonlite::validate(txt)) {
      txt <- sub(".*\\r\\n\\r\\n", "", txt)
      txt <- sub("\\r\\n--.*$", "", txt)
    }
    parsed <- jsonlite::fromJSON(txt, simplifyVector = FALSE)
    if (is.character(parsed) && length(parsed) == 1L && jsonlite::validate(parsed)) {
      parsed <- jsonlite::fromJSON(parsed, simplifyVector = FALSE)
    }
    parsed
  }
  parse_upload <- function(req) {
    if (!is.null(req$options$readfunction)) {
      return(req$options$readfunction(req$options$postfieldsize_large %||% 1e6))
    }
    req$options$postfields %||% raw()
  }
  selected_docs <- function(db_env, selector) {
    docs <- lapply(user_docs(db_env), function(id) get(id, db_env$docs, inherits = FALSE))
    if (length(docs) == 0) return(list())
    keep <- vapply(docs, function(doc) {
      if (is.null(selector) || length(selector) == 0) return(TRUE)
      all(vapply(names(selector), function(field) {
        condition <- selector[[field]]
        value <- doc[[field]]
        if (is.list(condition) && "$gt" %in% names(condition)) return(!is.null(value))
        if (is.list(condition) && !is.null(condition$`$regex`)) {
          return(!is.null(value) && grepl(condition$`$regex`, as.character(value)))
        }
        identical(value, condition)
      }, logical(1)))
    }, logical(1))
    docs[keep]
  }
  apply_fields <- function(doc, fields) {
    if (is.null(fields) || length(fields) == 0) return(doc)
    doc[names(doc) %in% unlist(fields, use.names = FALSE)]
  }
  page_rows <- function(rows, params) {
    if (!is.null(params$keys)) {
      keys <- unlist(params$keys, use.names = FALSE)
      rows <- rows[vapply(rows, function(x) x$id %in% keys || x$key %in% keys, logical(1))]
    }
    skip <- as.integer(params$skip %||% 0L)
    if (skip > 0) rows <- rows[seq.int(skip + 1L, length(rows))]
    if (!is.null(params$limit)) rows <- rows[seq_len(min(as.integer(params$limit), length(rows)))]
    rows
  }
  view_rows <- function(db_env, design, view) {
    design_id <- paste0("_design/", design)
    if (!exists(design_id, db_env$docs, inherits = FALSE)) return(NULL)
    ddoc <- get(design_id, db_env$docs, inherits = FALSE)
    if (is.null(ddoc$views[[view]])) return(NULL)
    map <- ddoc$views[[view]]$map
    docs <- lapply(user_docs(db_env), function(id) get(id, db_env$docs, inherits = FALSE))
    lapply(docs, function(doc) {
      value <- if (grepl("doc.Country,doc.imdbRating", map, fixed = TRUE)) {
        list(doc$Country, doc$imdbRating)
      } else if (grepl("doc.Country", map, fixed = TRUE)) {
        doc$Country
      } else {
        doc_copy(doc)
      }
      key <- if (grepl("emit(doc._id", map, fixed = TRUE)) doc$`_id` else NULL
      list(id = doc$`_id`, key = key, value = value)
    })
  }

  function(req) {
    method <- toupper(req$method)
    url <- req$url$url
    path <- parse_path(url)
    query <- parse_query(url)
    parts <- strsplit(path, "/", fixed = TRUE)[[1]]
    parts <- parts[nzchar(parts)]

    if (path == "/" && method == "GET") {
      return(fake_response(req, list(couchdb = "Welcome", version = "3.3.3", vendor = list(name = "The Apache Software Foundation"))))
    }
    if (path == "/_active_tasks" && method == "GET") {
      return(fake_response(req, list()))
    }
    if (path == "/_all_dbs" && method == "GET") {
      return(fake_response(req, as.list(sort(ls(state$dbs, all.names = TRUE)))))
    }
    if (path == "/_membership" && method == "GET") {
      return(fake_response(req, list(all_nodes = list("sofa@127.0.0.1"), cluster_nodes = list("sofa@127.0.0.1"))))
    }
    if (path == "/_restart" && method == "POST") {
      return(fake_response(req, list(ok = TRUE)))
    }
    if (path == "/_replicate" && method == "POST") {
      body <- parse_body(req)
      return(fake_response(req, list(
        ok = TRUE,
        history = list(),
        session_id = "fake-session",
        source_last_seq = 0L,
        source = body$source,
        target = body$target
      )))
    }
    if (path == "/_session" && method == "GET") {
      return(fake_response(req, list(ok = TRUE, userCtx = list(name = NULL, roles = list()), info = list(authenticated = "default"))))
    }
    if (path == "/_uuids" && method == "GET") {
      count <- as.integer(query$count %||% 1L)
      return(fake_response(req, list(uuids = as.list(vapply(seq_len(count), function(x) next_uuid(), "")))))
    }

    db <- parts[1]
    db_env <- get_db(db)

    if (length(parts) == 1L && method == "PUT") {
      if (db_exists(db)) {
        return(fake_error(req, 412L, "file_exists", "The database could not be created, the file already exists."))
      }
      db_env <- new.env(parent = emptyenv())
      db_env$docs <- new.env(parent = emptyenv())
      db_env$attachments <- new.env(parent = emptyenv())
      db_env$indexes <- list(list(ddoc = NULL, name = "_all_docs", type = "special", def = list(fields = list(list(`_id` = "asc")))))
      db_env$seq <- 0L
      db_env$changes <- list()
      assign(db, db_env, state$dbs)
      return(fake_response(req, list(ok = TRUE), 201L))
    }
    if (is.null(db_env)) return(fake_error(req, 404L, "not_found", "Database does not exist."))

    if (length(parts) == 1L && method == "DELETE") {
      rm(list = db, envir = state$dbs)
      return(fake_response(req, list(ok = TRUE)))
    }
    if (length(parts) == 1L && method == "GET") {
      return(fake_response(req, list(
        db_name = db,
        sizes = list(file = 0L, external = 0L, active = 0L),
        doc_count = length(user_docs(db_env)),
        doc_del_count = 0L,
        update_seq = db_env$seq
      )))
    }
    if (length(parts) == 1L && method == "POST") {
      id <- next_uuid()
      doc <- save_doc(db_env, id, parse_body(req))
      return(fake_response(req, list(ok = TRUE, id = id, rev = doc$`_rev`), 201L))
    }

    endpoint <- parts[2]
    if (endpoint == "_all_docs" && method == "GET") {
      ids <- user_docs(db_env)
      rows <- lapply(ids, function(id) {
        doc <- get(id, db_env$docs, inherits = FALSE)
        row <- list(id = id, key = id, value = list(rev = doc$`_rev`))
        if (identical(query$include_docs, "true")) row$doc <- doc_copy(doc)
        row
      })
      total <- length(rows)
      rows <- page_rows(rows, query)
      return(fake_response(req, list(total_rows = total, offset = 0L, rows = rows)))
    }
    if (endpoint == "_changes" && method == "GET") {
      return(fake_response(req, list(results = db_env$changes, last_seq = db_env$seq, pending = 0L)))
    }
    if (endpoint == "_bulk_docs" && method == "POST") {
      out <- lapply(parse_body(req)$docs, function(doc) {
        id <- doc$`_id` %||% next_uuid()
        doc <- save_doc(db_env, id, doc)
        list(ok = TRUE, id = id, rev = doc$`_rev`)
      })
      return(fake_response(req, out, 201L))
    }
    if (endpoint == "_bulk_get" && method == "POST") {
      results <- lapply(parse_body(req)$docs, function(x) {
        doc <- get(x$id, db_env$docs, inherits = FALSE)
        list(id = x$id, docs = list(list(ok = doc_copy(doc))))
      })
      return(fake_response(req, list(results = results)))
    }
    if (endpoint == "_find" && method == "POST") {
      body <- parse_body(req)
      docs <- selected_docs(db_env, body$selector)
      start <- as.integer(body$bookmark %||% "0") + 1L
      docs <- if (start > length(docs)) list() else docs[start:length(docs)]
      if (!is.null(body$limit)) docs <- docs[seq_len(min(as.integer(body$limit), length(docs)))]
      docs <- lapply(docs, apply_fields, fields = body$fields)
      return(fake_response(req, list(
        warning = "no matching index found, create an index to optimize query time",
        docs = docs,
        bookmark = as.character((start - 1L) + length(docs))
      )))
    }
    if (endpoint == "_explain" && method == "POST") {
      body <- parse_body(req)
      return(fake_response(req, list(dbname = db, selector = body$selector, fields = "all_fields")))
    }
    if (endpoint == "_compact" && method == "POST") {
      return(fake_response(req, list(ok = TRUE), 202L))
    }
    if (endpoint == "_index") {
      if (length(parts) == 2L && method == "GET") {
        return(fake_response(req, list(total_rows = length(db_env$indexes), indexes = db_env$indexes)))
      }
      if (length(parts) == 2L && method == "POST") {
        body <- parse_body(req)
        idx <- list(
          ddoc = body$ddoc %||% paste0("_design/", body$name %||% "idx"),
          name = body$name %||% "idx",
          type = body$type %||% "json",
          def = body$index
        )
        db_env$indexes[[length(db_env$indexes) + 1L]] <- idx
        return(fake_response(req, list(result = "created", id = idx$ddoc, name = idx$name)))
      }
      if (length(parts) >= 5L && method == "DELETE") {
        ddoc <- paste(parts[3:(length(parts) - 2L)], collapse = "/")
        name <- parts[length(parts)]
        db_env$indexes <- Filter(function(x) {
          !identical(x$ddoc, ddoc) || !identical(x$name, name)
        }, db_env$indexes)
        return(fake_response(req, list(ok = TRUE)))
      }
    }
    if (endpoint == "_design") {
      design <- parts[3]
      if (length(parts) == 3L && method == "PUT") {
        doc <- save_doc(db_env, paste0("_design/", design), parse_body(req))
        return(fake_response(req, list(ok = TRUE, id = doc$`_id`, rev = doc$`_rev`), 201L))
      }
      if (length(parts) == 4L && parts[4] == "_info" && method == "GET") {
        design_id <- paste0("_design/", design)
        if (!exists(design_id, db_env$docs, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
        return(fake_response(req, list(name = design, view_index = list(signature = "fake", language = "javascript"))))
      }
      if (length(parts) >= 5L && parts[4] == "_view") {
        rows <- view_rows(db_env, design, parts[5])
        if (is.null(rows)) return(fake_error(req, 404L, "not_found", "missing_named_view"))
        if (length(parts) == 6L && parts[6] == "queries") {
          results <- lapply(parse_body(req)$queries, function(q) {
            out <- page_rows(rows, q)
            list(total_rows = length(out), offset = as.integer(q$skip %||% 0L), rows = out)
          })
          return(fake_response(req, list(results = results)))
        }
        params <- if (method == "POST") parse_body(req) else query
        rows <- page_rows(rows, params)
        return(fake_response(req, list(total_rows = length(rows), offset = 0L, rows = rows)))
      }
    }

    if (length(parts) >= 3L && !startsWith(endpoint, "_")) {
      id <- parts[2]
      attname <- paste(parts[-c(1, 2)], collapse = "/")
      key <- paste(id, attname, sep = "/")
      if (method == "PUT") {
        if (!exists(id, db_env$docs, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
        doc <- get(id, db_env$docs, inherits = FALSE)
        doc$`_attachments` <- doc$`_attachments` %||% list()
        body <- parse_upload(req)
        doc$`_attachments`[[attname]] <- list(
          content_type = req$headers$`Content-Type` %||% "application/octet-stream",
          length = length(body),
          stub = TRUE
        )
        doc <- save_doc(db_env, id, doc)
        assign(key, body, db_env$attachments)
        return(fake_response(req, list(ok = TRUE, id = id, rev = doc$`_rev`), 201L))
      }
      if (method == "HEAD") {
        if (!exists(key, db_env$attachments, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
        doc <- get(id, db_env$docs, inherits = FALSE)
        return(fake_response(req, list(), headers = list(rev = doc$`_rev`, `content-type` = doc$`_attachments`[[attname]]$content_type)))
      }
      if (method == "GET") {
        if (!exists(key, db_env$attachments, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
        return(fake_raw_response(req, get(key, db_env$attachments, inherits = FALSE), headers = list(`content-type` = "application/octet-stream")))
      }
      if (method == "DELETE") {
        if (!exists(key, db_env$attachments, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
        rm(list = key, envir = db_env$attachments)
        doc <- get(id, db_env$docs, inherits = FALSE)
        doc$`_attachments`[[attname]] <- NULL
        doc <- save_doc(db_env, id, doc)
        return(fake_response(req, list(ok = TRUE, id = id, rev = doc$`_rev`)))
      }
    }

    id <- paste(parts[-1], collapse = "/")
    if (method == "HEAD") {
      if (!exists(id, db_env$docs, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
      doc <- get(id, db_env$docs, inherits = FALSE)
      return(fake_response(req, list(), headers = list(rev = doc$`_rev`)))
    }
    if (method == "GET") {
      if (!exists(id, db_env$docs, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
      doc <- doc_copy(get(id, db_env$docs, inherits = FALSE))
      if (identical(query$revs_info, "true")) {
        doc$`_revs_info` <- list(list(rev = doc$`_rev`, status = "available"))
      }
      return(fake_response(req, doc))
    }
    if (method == "PUT") {
      doc <- save_doc(db_env, id, parse_body(req))
      return(fake_response(req, list(ok = TRUE, id = id, rev = doc$`_rev`), 201L))
    }
    if (method == "DELETE") {
      if (!exists(id, db_env$docs, inherits = FALSE)) return(fake_error(req, 404L, "not_found", "missing"))
      rm(list = id, envir = db_env$docs)
      return(fake_response(req, list(ok = TRUE, id = id, rev = next_rev())))
    }

    fake_error(req, 404L, "not_found", "missing")
  }
}

start_fake_couchdb <- function() {
  old_mock <- getOption("crul_mock")
  options(crul_mock = new_fake_couchdb())
  list(
    cushion = function() Cushion$new(host = "sofa.test", port = NULL, transport = "http"),
    stop = function() options(crul_mock = old_mock)
  )
}

use_real_couchdb <- identical(tolower(Sys.getenv("SOFA_TEST_REAL_COUCHDB")), "true")

if (use_real_couchdb) {
  COUCHDB_TEST_HOST <- envvar("COUCHDB_TEST_HOST", "127.0.0.1")
  COUCHDB_TEST_USER <- envvar("COUCHDB_TEST_USER")
  COUCHDB_TEST_PWD <- envvar("COUCHDB_TEST_PWD")
  COUCHDB_TEST_TRANSPORT <- envvar("COUCHDB_TEST_TRANSPORT", "http")
  COUCHDB_TEST_PORT <- envvar("COUCHDB_TEST_PORT", "5984")
  COUCHDB_TEST_PORT <- if (is.null(COUCHDB_TEST_PORT)) NULL else as.integer(COUCHDB_TEST_PORT)

  sofa_args <- list(
    host = COUCHDB_TEST_HOST,
    transport = COUCHDB_TEST_TRANSPORT,
    port = COUCHDB_TEST_PORT
  )
  if (!is.null(COUCHDB_TEST_USER) && !is.null(COUCHDB_TEST_PWD)) {
    sofa_args$user <- COUCHDB_TEST_USER
    sofa_args$pwd <- COUCHDB_TEST_PWD
  }
  invisible(sofa_conn <- do.call(Cushion$new, sofa_args))
  pinged <- tryCatch(sofa_conn$ping(), error = function(e) e)
} else {
  .sofa_fake_server <- start_fake_couchdb()
  sofa_conn <- .sofa_fake_server$cushion()
  pinged <- sofa_conn$ping()
}

dbname_random <- function() {
  paste0(sample(letters, 10, replace = TRUE), collapse = "")
}

cleanup_dbs <- function(x) invisible(db_delete(sofa_conn, x))

skip_if_no_couchdb <- function() {
  testthat::skip_if(
    inherits(pinged, "error"),
    paste("CouchDB test server is not available at", sofa_conn$make_url())
  )
}

if (!inherits(pinged, "error")) {
  db_test_name <- "testing123"
  if (!db_test_name %in% db_list(sofa_conn)) {
    db_create(sofa_conn, dbname = db_test_name)
  }
  invisible(db_bulk_create(sofa_conn, dbname = db_test_name, doc = iris))
}
