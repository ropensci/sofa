#' sofa connection client
#'
#' @export
#' @param host (character) A base URL (without the transport), e.g., \code{localhost},
#' \code{127.0.0.1}, or \code{foobar.cloudant.com}
#' @param port (numeric) Port. Remember that if you don't want a port set, set this
#' parameter to \code{NULL}. Default: \code{5984}
#' @param path (character) context path that is appended to the end of the url. e.g.,
#' \code{bar} in \code{http://foo.com/bar}. Default: NULL, ignored
#' @param transport (character) http or https. Default: http
#' @param user (character) A user name
#' @param pwd (character) A password
#' @param headers Either an object of class \code{request} or a list that can be coerced
#' to an object of class \code{request} via \code{\link[httr]{add_headers}}. These headers
#' are used in all requests. To use headers in individual requests and not others, pass
#' in headers using \code{\link[httr]{add_headers}} via \code{...} in a function call.
#'
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{ping()}}{
#'       Ping the CouchDB server
#'     }
#'     \item{\code{make_url()}}{
#'       Construct full base URL from the pieces in the connection object
#'     }
#'     \item{\code{get_headers()}}{
#'       Get headers that will be sent with each request
#'     }
#'   }
#'
#' @format NULL
#' @usage NULL
#'
#' @return An object of class \code{Cushion}, with variables accessible for
#' host, port, path, transport, user, pwd, and headers. Functions are callable
#' to get headers, and to make the base url sent with all requests.
#'
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' (x <- Cushion$new())
#'
#' ## metadata
#' x$host
#' x$path
#' x$port
#' x$type
#'
#' ## ping the CouchDB server
#' x$ping()
#'
#' ## CouchDB server statistics
#' # stats(x)
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
#'
#' # Using Cloudant
#' z <- Cushion$new(host = "ropensci.cloudant.com", transport = 'https', port = NULL,
#'    user = 'ropensci', pwd = Sys.getenv('CLOUDANT_PWD'))
#' z
#' db_list(z)
#' db_create(z, "stuff2")
#' db_info(z, "stuff2")
#' alldocs(z, "foobar")
#' }
Cushion <- R6::R6Class(
  "Cushion",
  public = list(
    host = '127.0.0.1',
    port = 5984,
    path = NULL,
    transport = 'http',
    user = NULL,
    pwd = NULL,
    headers = NULL,

    initialize = function(host, port, path, transport, user, pwd, headers) {
      if (!missing(host)) self$host <- host
      if (!missing(port)) self$port <- port
      if (!missing(path)) self$path <- path
      if (!missing(transport)) self$transport <- transport
      if (!missing(user)) self$user <- user
      if (!missing(pwd)) self$pwd <- pwd
      if (!missing(user) && !missing(pwd)) {
        private$auth_headers <- httr::authenticate(user = user, password = pwd)
      }
      if (!missing(headers)) self$headers <- headers
    },

    print = function() {
      cat("<sofa - cushion> ", sep = "\n")
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
      sofa_GET(self$make_url(), ...)
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
    },

    get_headers = function() {
      c(private$auth_headers, self$headers)
    }
  ),

  private = list(
    auth_headers = NULL
  )
)

check_cushion <- function(x) {
  if (!inherits(x, "Cushion")) {
    stop("input must be a sofa Cushion object, see ?Cushion", call. = FALSE)
  }
}
