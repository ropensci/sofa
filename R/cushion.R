#' sofa connection client
#'
#' @export
#' @param name (character) Name for the cushion. This is what you'll call in sofa functions to get these
#' details.
#' @param host (character) A base URL, not needed if \code{type=localhost|cloudant|iriscouch}. Though
#' you can pass a base URL in here to override anything done internally.
#' @param port (numeric) Port. Only applies when type is localhost. Default: 5984
#' @param path (character) context path that is appended to the end of the url.
#' Default: NULL, ignored
#' @param user (character) A user name
#' @param pwd (character) A password
#' @param type (character) One of localhost, cloudant, iriscouch, or \code{NULL}. This is what's
#' used to determine how to structure the URL to make the request. If left to the
#' default of \code{NULL}, you must pass in a base URL.
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{ping()}}{
#'       Ping the CouchDB server
#'     }
#'     \item{\code{make_url()}}{
#'       Construct full base URL from the pieces in the connection object
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' (x <- Cushion$new(name = "foobar"))
#'
#' ## metadata
#' x$host
#' x$path
#' x$name
#' x$port
#' x$type
#'
#' ## ping the CouchDB server
#' x$ping()
#'
#' ## CouchDB server statistics
#' stats(x)
#'
#' ## database info
#' db_info(x, "bulktest")
#'
#' ## list dbs
#' db_list(x)
#'
#' ## all docs
#' alldocs(x, "bulktest", limit = 3)
#'
#' ## changes
#' changes(x, "bulktest")
#'
#' # create database
#' db_create(x, "stuff")
#'
#' # add documents to a database
#' db_create(x, "sofadb")
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="sofadb", docid="abeer", doc1)
#'
#' # bulk create
#' db_create(x, "mymtcars")
#' bulk_create(x, dbname="mymtcars", doc = mtcars)
#' db_list(x)
#'
#' # Using Cloudant
#' # (z <- Cushion$new('foobar', type="cloudant",
#' #   user = 'ropensci', pwd = 'agXX9ypzYDD3FqcLKvWGQiFZx'))
#' # z$db_info()
#' # z$alldocs(limit = 2)
#'
#' ## create a cloudant db
#' # (z <- Cushion$new('stuff', type="cloudant",
#' #     user = 'ropensci', pwd = 'agXX9ypzYDD3FqcLKvWGQiFZx'))
#' # z$db_create()
#' }
Cushion <- R6::R6Class(
  "Cushion",
  public = list(
    name = NULL,
    host = NULL,
    port = 5984,
    path = NULL,
    transport = 'http',
    user = NULL,
    pwd = NULL,
    type = 'localhost',

    initialize = function(name, host = '127.0.0.1', port = 5984, path, transport = 'http',
                          user, pwd, type = 'localhost') {

      if (!missing(name)) self$name <- name
      if (!missing(host)) {
        self$host <- host
      } else {
        self$host <-
          switch(type,
                 localhost = '127.0.0.1',
                 cloudant = 'cloudant.com',
                 iriscouch = 'iriscouch.com')
      }
      if (!missing(port)) self$port <- port
      if (!missing(path)) self$path <- path
      if (!missing(user)) self$user <- user
      if (!missing(pwd)) self$pwd <- pwd
      if (!missing(type)) self$type <- type
    },

    print = function() {
      cat(paste0("<sofa - cushion> ", self$name), sep = "\n")
      cat(paste0("  transport: ", self$transport), sep = "\n")
      cat(paste0("  host: ", self$host), sep = "\n")
      cat(paste0("  port: ", self$port), sep = "\n")
      cat(paste0("  path: ", self$path), sep = "\n")
      cat(paste0("  type: ", self$type), sep = "\n")
      cat(paste0("  user: ", self$user), sep = "\n")
      cat(paste0("  pwd: ", if (!is.null(self$pwd)) '<secret>' else ''), sep = "\n")
      invisible(self)
    },

    ping = function(...) {
      sofa_GET(private$make_url(), ...)
    },

    make_url = function() {
      tmp <- sprintf("%s://%s", self$transport, self$host)
      if (!is.null(self$port)) {
        tmp <- sprintf("%s:%s", tmp, self$port)
      }
      if (!is.null(self$path)) {
        tmp <- sprintf("%s/%s", tmp, self$path)
      }
      tmp
    }
  )
)

check_cushion <- function(x) {
  if (!inherits(x, "Cushion")) {
    stop("input must be a sofa Cushion object, see ?Cushion", call. = FALSE)
  }
}
