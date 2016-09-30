#' CouchDB R6 client
#'
#' @export
#' @param name Name for the cushion. This is what you'll call in sofa functions to get these
#' details.
#' @param user A user name
#' @param pwd A password
#' @param base A base URL, not needed if \code{type=localhost|cloudant|iriscouch}. Though
#' you can pass a base URL in here to override anything done internally.
#' @param type One of localhost, cloudant, iriscouch, or \code{NULL}. This is what's
#' used to determine how to structure the URL to make the request. If left to the
#' default of \code{NULL}, you must pass in a base URL.
#' @param port Port. Only applies when type is localhost. Default: 5984
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{eject()}}{
#'       Coming soon.
#'     }
#'     \item{\code{file()}}{
#'       Get path to the man file for the cassette.
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' (x <- Cushion$new(name = "glopnet"))
#' ## metadata
#' x$base
#' x$name
#' x$port
#' x$type
#'
#' ## database info
#' x$db_info()
#'
#' ## all docs
#' x$alldocs(limit = 10)
#'
#' ## changes
#' x$changes()
#'
#' # Without db name existing
#' (y <- Cushion$new(name = "foobar"))
#' y$db_create()
#'
#' # Using Cloudant
#' (z <- Cushion$new('foobar', type="cloudant",
#'    user = 'ropensci', pwd = 'agXX9ypzYDD3FqcLKvWGQiFZx'))
#' z$db_info()
#' z$alldocs(limit = 2)
#'
#' ## create a cloudant db
#' (z <- Cushion$new('stuff', type="cloudant",
#'    user = 'ropensci', pwd = 'agXX9ypzYDD3FqcLKvWGQiFZx'))
#' z$db_create()
#' }
Cushion <- R6::R6Class(
  "Cushion",
  public = list(
    name = NULL,
    user = NULL,
    pwd = NULL,
    base = NULL,
    type = 'localhost',
    port = 5984,

    initialize = function(name, user, pwd, base, type = 'localhost', port = 5984) {
      if (!missing(name)) self$name <- name
      if (!missing(user)) self$user <- user
      if (!missing(pwd)) self$pwd <- pwd
      if (!missing(base)) {
        self$base <- base
      } else {
        self$base <-
          switch(type,
                 localhost = 'http://127.0.0.1',
                 cloudant = 'https://cloudant.com',
                 iriscouch = 'https://iriscouch.com')
      }
      if (!missing(type)) self$type <- type
      if (!missing(port)) self$port <- port
    },

    print = function() {
      cat("<sofa - cushion> ", sep = "\n")
      cat(paste0("  Database: ", self$name), sep = "\n")
      cat(paste0("  Port: ", self$port), sep = "\n")
      cat(paste0("  Type: ", self$type), sep = "\n")
      cat(paste0("  Base URL: ", self$base), sep = "\n")
      cat(paste0("  User: ", self$user), sep = "\n")
      cat(paste0("  Pwd: ", if (!is.null(self$pwd)) '<secret>' else ''), sep = "\n")
      invisible(self)
    },

    db_info = function(as = 'list', ...) {
      if (self$type == "localhost") {
        sofa_GET(sprintf("http://127.0.0.1:%s/%s", self$port, self$name), as, ...)
      } else if (self$type %in% c("cloudant", 'iriscouch')) {
        sofa_GET(private$remote_url(), as, content_type_json(), ...)
      }
    },

    db_create = function(delifexists = FALSE, as = 'list', ...) {
      if (delifexists) self$db_delete()
      if (self$type == "localhost") {
        sofa_PUT(sprintf("http://127.0.0.1:%s/%s", self$port, self$name), as, ...)
      } else if (self$type %in% c("cloudant",'iriscouch')) {
        sofa_PUT(private$remote_url(), as, ...)
      }
    },

    db_delete = function(as = 'list', ...) {
      if (self$type == "localhost") {
        sofa_DELETE(sprintf("http://127.0.0.1:%s/%s", self$port, self$name), as, ...)
      } else if (self$type %in% c("cloudant", 'iriscouch')) {
        sofa_DELETE(private$remote_url(), as, content_type_json(), ...)
      }
    },

    alldocs = function(asdf = TRUE, descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, include_docs=NULL, as='list', ...) {
      args <- sc(list(descending = descending, startkey = startkey, endkey = endkey,
                      limit = limit, include_docs = include_docs))
      if (self$type == "localhost") {
        call_ <- sprintf("http://127.0.0.1:%s/%s/_all_docs", self$port, self$name)
        temp <- sofa_GET(call_, as, query = args, ...)
      } else if (self$type %in% c("cloudant", 'iriscouch')) {
        temp <- sofa_GET(private$remote_url("_all_docs"), as, query = args, content_type_json(), ...)
      }

      if (as == 'json') {
        temp
      } else {
        if (asdf & is.null(include_docs)) ldply(temp$rows, data.frame, stringsAsFactors = FALSE) else temp
      }
    },

    changes = function(descending=NULL, startkey=NULL, endkey=NULL, since=NULL, limit=NULL,
                       include_docs=NULL, feed="normal", heartbeat=NULL, filter=NULL, as='list', ...) {
      args <- sc(list(descending = descending, startkey = startkey, endkey = endkey,
                      since = since, limit = limit, include_docs = include_docs, feed = feed,
                      heartbeat = heartbeat, filter = filter))
      if (self$type == "localhost") {
        call_ <- sprintf("http://127.0.0.1:%s/%s/_changes", self$port, self$name)
        sofa_GET(call_, as, query = args, ...)
      } else if (self$type %in% c("cloudant", 'iriscouch')) {
        sofa_GET(private$remote_url("_changes"), as, query = args, content_type_json(), ...)
      }
    },

    bulk_create = function(x, docid = NULL, how = 'rows', as = 'list', ...) {
      row.names(x) <- NULL
      each <- unname(parse_df(x, how = how, tojson = FALSE))
      body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
      sofa_bulk(file.path(private$get_url(), "_bulk_docs"), as, body = body, ...)
    }

    # bulky_create.data.frame = function(x, docid = NULL, how = 'rows', as = 'list', ...) {
    #   row.names(x) <- NULL
    #   each <- unname(parse_df(x, how = how, tojson = FALSE))
    #   body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
    #   sofa_bulk(file.path(private$get_url(), "_bulk_docs"), as, body = body, ...)
    # }
  ),

  private = list(
    get_url = function() {
      if (self$type == "localhost") {
        sprintf("http://127.0.0.1:%s/%s", self$port, self$name)
      } else if (self$type %in% c("cloudant", 'iriscouch')) {
        private$remote_url()
      }
    },

    remote_url = function(endpt = NULL) {
      switch(self$type, cloudant = private$cloudant_url(endpt), iriscouch = private$iris_url(endpt))
    },

    cloudant_url = function(endpt = NULL) {
      if (is.null(self$name)) {
        paste(sprintf('https://%s:%s@%s.cloudant.com', self$user, self$pwd, self$user), endpt, sep = "/")
      } else if (is.null(endpt)) {
        paste(sprintf('https://%s:%s@%s.cloudant.com', self$user, self$pwd, self$user), self$name, sep = "/")
      } else {
        paste(sprintf('https://%s:%s@%s.cloudant.com', self$user, self$pwd, self$user), self$name, endpt, sep = "/")
      }
    },

    iris_url = function(endpt = NULL) {
      if (is.null(dbname)) {
        paste(sprintf('https://%s.iriscouch.com', self$user), endpt, sep = "/")
      } else if (is.null(endpt)) {
        paste(sprintf('https://%s.iriscouch.com', self$user), self$name, sep = "/")
      } else {
        paste(sprintf('https://%s.iriscouch.com', self$user), self$name, endpt, sep = "/")
      }
    }
  )
)

bulk_create.character <- function(x, docid = NULL, how = 'rows', as = 'list', ...) {
  body <- sprintf('{"docs": [%s]}', paste0(x, collapse = ", "))
  sofa_bulk(file.path(private$get_url(), "_bulk_docs"), as, body = body, ...)
}

bulk_create.list <- function(x, docid = NULL, how = 'rows', as = 'list', ...) {
  body <- jsonlite::toJSON(list(docs = x), auto_unbox = TRUE)
  sofa_bulk(file.path(private$get_url(), "_bulk_docs"), as, body = body, ...)
}

bulk_create.data.frame <- function(x, docid = NULL, how = 'rows', as = 'list', ...) {
  row.names(x) <- NULL
  each <- unname(parse_df(x, how = how, tojson = FALSE))
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(private$get_url(), "_bulk_docs"), as, body = body, ...)
}

