library(sofa)

envvar <- function(x, default = NULL) {
  value <- Sys.getenv(x)
  if (nzchar(value)) value else default
}

`%||%` <- function(x, y) if (is.null(x)) y else x

new_fake_couchdb_app <- function() {
  `%||%` <- function(x, y) if (is.null(x)) y else x
  json_response <- function(res, body, status = 200L) {
    res$set_status(status)
    res$set_type("application/json")
    res$send(jsonlite::toJSON(body, auto_unbox = TRUE, null = "null"))
  }
  couch_error <- function(res, status, error, reason) {
    json_response(res, list(error = error, reason = reason), status)
  }

  state <- new.env(parent = emptyenv())
  state$dbs <- new.env(parent = emptyenv())
  state$uuid <- 0L

  app <- webfakes::new_app()
  app$use(webfakes::mw_raw(type = "application/json"))
  app$use(webfakes::mw_multipart())

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
  get_db <- function(db, res) {
    if (!db_exists(db)) {
      couch_error(res, 404L, "not_found", "Database does not exist.")
      return(NULL)
    }
    get(db, state$dbs, inherits = FALSE)
  }
  body_json <- function(req) {
    if (!is.null(req$raw) && length(req$raw)) {
      parsed <- jsonlite::fromJSON(rawToChar(req$raw), simplifyVector = FALSE)
      if (is.character(parsed) && length(parsed) == 1L && jsonlite::validate(parsed)) {
        parsed <- jsonlite::fromJSON(parsed, simplifyVector = FALSE)
      }
      return(parsed)
    }
    if (!is.null(req$form) && length(req$form)) {
      txt <- unname(unlist(req$form, use.names = FALSE))[1]
      return(jsonlite::fromJSON(txt, simplifyVector = FALSE))
    }
    list()
  }
  user_docs <- function(db_env) {
    ids <- sort(ls(db_env$docs, all.names = TRUE))
    ids[!startsWith(ids, "_design/")]
  }
  doc_copy <- function(doc) {
    doc[!names(doc) %in% "_deleted"]
  }
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
  selected_docs <- function(db_env, selector) {
    docs <- lapply(user_docs(db_env), function(id) get(id, db_env$docs, inherits = FALSE))
    if (length(docs) == 0) return(list())
    keep <- vapply(docs, function(doc) {
      if (is.null(selector) || length(selector) == 0) return(TRUE)
      all(vapply(names(selector), function(field) {
        condition <- selector[[field]]
        value <- doc[[field]]
        if (is.list(condition) && "$gt" %in% names(condition)) {
          return(!is.null(value))
        }
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
  page_rows <- function(rows, params) {
    if (!is.null(params$keys)) {
      keys <- unlist(params$keys, use.names = FALSE)
      rows <- rows[vapply(rows, function(x) x$id %in% keys || x$key %in% keys, logical(1))]
    }
    skip <- as.integer(params$skip %||% 0L)
    limit <- params$limit
    if (skip > 0) rows <- rows[seq.int(skip + 1L, length(rows))]
    if (!is.null(limit)) rows <- rows[seq_len(min(as.integer(limit), length(rows)))]
    rows
  }

  app$get("/", function(req, res) {
    json_response(res, list(couchdb = "Welcome", version = "3.3.3", vendor = list(name = "The Apache Software Foundation")))
  })
  app$get("/_all_dbs", function(req, res) {
    json_response(res, as.list(sort(ls(state$dbs, all.names = TRUE))))
  })
  app$put(webfakes::new_regexp("^/[^/]+$"), function(req, res) {
    db <- sub("^/", "", req$path)
    if (db_exists(db)) {
      return(couch_error(res, 412L, "file_exists", "The database could not be created, the file already exists."))
    }
    db_env <- new.env(parent = emptyenv())
    db_env$docs <- new.env(parent = emptyenv())
    db_env$seq <- 0L
    db_env$changes <- list()
    assign(db, db_env, state$dbs)
    json_response(res, list(ok = TRUE), 201L)
  })
  app$delete(webfakes::new_regexp("^/[^/]+$"), function(req, res) {
    db <- sub("^/", "", req$path)
    if (!db_exists(db)) return(couch_error(res, 404L, "not_found", "Database does not exist."))
    rm(list = db, envir = state$dbs)
    json_response(res, list(ok = TRUE), 200L)
  })
  app$get(webfakes::new_regexp("^/[^/]+$"), function(req, res) {
    db <- sub("^/", "", req$path)
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    json_response(res, list(
      db_name = db,
      sizes = list(file = 0L, external = 0L, active = 0L),
      doc_count = length(user_docs(db_env)),
      doc_del_count = 0L,
      update_seq = db_env$seq
    ))
  })
  app$post(webfakes::new_regexp("^/[^/]+$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    doc <- body_json(req)
    id <- next_uuid()
    doc <- save_doc(db_env, id, doc)
    json_response(res, list(ok = TRUE, id = id, rev = doc$`_rev`), 201L)
  })
  app$get(webfakes::new_regexp("^/[^/]+/_all_docs$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    ids <- user_docs(db_env)
    rows <- lapply(ids, function(id) {
      doc <- get(id, db_env$docs, inherits = FALSE)
      row <- list(id = id, key = id, value = list(rev = doc$`_rev`))
      if (identical(req$query$include_docs, "true")) row$doc <- doc_copy(doc)
      row
    })
    total <- length(rows)
    rows <- page_rows(rows, req$query)
    json_response(res, list(total_rows = total, offset = 0L, rows = rows))
  })
  app$get(webfakes::new_regexp("^/[^/]+/_changes$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    json_response(res, list(results = db_env$changes, last_seq = db_env$seq, pending = 0L))
  })
  app$post(webfakes::new_regexp("^/[^/]+/_bulk_docs$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    body <- body_json(req)
    out <- lapply(body$docs, function(doc) {
      id <- doc$`_id` %||% next_uuid()
      doc <- save_doc(db_env, id, doc)
      list(ok = TRUE, id = id, rev = doc$`_rev`)
    })
    json_response(res, out, 201L)
  })
  app$post(webfakes::new_regexp("^/[^/]+/_bulk_get$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    body <- body_json(req)
    results <- lapply(body$docs, function(x) {
      doc <- get(x$id, db_env$docs, inherits = FALSE)
      list(id = x$id, docs = list(list(ok = doc_copy(doc))))
    })
    json_response(res, list(results = results))
  })
  app$post(webfakes::new_regexp("^/[^/]+/_find$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    db_env <- get_db(db, res)
    if (is.null(db_env)) return()
    body <- body_json(req)
    docs <- selected_docs(db_env, body$selector)
    start <- as.integer(body$bookmark %||% "0") + 1L
    if (start > length(docs)) docs <- list() else docs <- docs[start:length(docs)]
    if (!is.null(body$limit)) docs <- docs[seq_len(min(as.integer(body$limit), length(docs)))]
    docs <- lapply(docs, apply_fields, fields = body$fields)
    out <- list(
      warning = "no matching index found, create an index to optimize query time",
      docs = docs,
      bookmark = as.character((start - 1L) + length(docs))
    )
    json_response(res, out)
  })
  app$post(webfakes::new_regexp("^/[^/]+/_explain$"), function(req, res) {
    db <- strsplit(req$path, "/", fixed = TRUE)[[1]][2]
    if (is.null(get_db(db, res))) return()
    body <- body_json(req)
    json_response(res, list(dbname = db, selector = body$selector, fields = "all_fields"))
  })
  app$put(webfakes::new_regexp("^/[^/]+/_design/[^/]+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    doc <- save_doc(db_env, paste0("_design/", parts[4]), body_json(req))
    json_response(res, list(ok = TRUE, id = doc$`_id`, rev = doc$`_rev`), 201L)
  })
  app$get(webfakes::new_regexp("^/[^/]+/_design/[^/]+/_view/[^/]+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    rows <- view_rows(db_env, parts[4], parts[6])
    if (is.null(rows)) return(couch_error(res, 404L, "not_found", "missing_named_view"))
    rows <- page_rows(rows, req$query)
    json_response(res, list(total_rows = length(rows), offset = 0L, rows = rows))
  })
  app$post(webfakes::new_regexp("^/[^/]+/_design/[^/]+/_view/[^/]+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    rows <- view_rows(db_env, parts[4], parts[6])
    if (is.null(rows)) return(couch_error(res, 404L, "not_found", "missing_named_view"))
    rows <- page_rows(rows, body_json(req))
    json_response(res, list(total_rows = length(rows), offset = 0L, rows = rows))
  })
  app$post(webfakes::new_regexp("^/[^/]+/_design/[^/]+/_view/[^/]+/queries$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    rows <- view_rows(db_env, parts[4], parts[6])
    body <- body_json(req)
    results <- lapply(body$queries, function(query) {
      out <- page_rows(rows, query)
      list(total_rows = length(out), offset = as.integer(query$skip %||% 0L), rows = out)
    })
    json_response(res, list(results = results))
  })
  app$head(webfakes::new_regexp("^/[^/]+/.+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    id <- paste(parts[-c(1, 2)], collapse = "/")
    if (!exists(id, db_env$docs, inherits = FALSE)) return(couch_error(res, 404L, "not_found", "missing"))
    doc <- get(id, db_env$docs, inherits = FALSE)
    res$set_header("rev", doc$`_rev`)$send_status(200L)
  })
  app$get(webfakes::new_regexp("^/[^/]+/.+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    id <- paste(parts[-c(1, 2)], collapse = "/")
    if (!exists(id, db_env$docs, inherits = FALSE)) return(couch_error(res, 404L, "not_found", "missing"))
    doc <- doc_copy(get(id, db_env$docs, inherits = FALSE))
    if (identical(req$query$revs_info, "true")) {
      doc$`_revs_info` <- list(list(rev = doc$`_rev`, status = "available"))
    }
    json_response(res, doc)
  })
  app$put(webfakes::new_regexp("^/[^/]+/.+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    id <- paste(parts[-c(1, 2)], collapse = "/")
    doc <- save_doc(db_env, id, body_json(req))
    json_response(res, list(ok = TRUE, id = id, rev = doc$`_rev`), 201L)
  })
  app$delete(webfakes::new_regexp("^/[^/]+/.+$"), function(req, res) {
    parts <- strsplit(req$path, "/", fixed = TRUE)[[1]]
    db_env <- get_db(parts[2], res)
    if (is.null(db_env)) return()
    id <- paste(parts[-c(1, 2)], collapse = "/")
    if (!exists(id, db_env$docs, inherits = FALSE)) return(couch_error(res, 404L, "not_found", "missing"))
    rm(list = id, envir = db_env$docs)
    json_response(res, list(ok = TRUE, id = id, rev = next_rev()), 200L)
  })

  app
}

start_fake_couchdb <- function() {
  proc <- webfakes::new_app_process(new_fake_couchdb_app(), start = TRUE)
  url <- proc$url("/")
  parts <- strsplit(sub("^http://", "", sub("/$", "", url)), ":", fixed = TRUE)[[1]]
  list(
    url = url,
    cushion = function() Cushion$new(host = parts[1], port = as.integer(parts[2]), transport = "http"),
    stop = function() proc$stop()
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

