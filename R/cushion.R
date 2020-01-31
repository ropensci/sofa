#' sofa connection client
#'
#' @export
#' @section CouchDB versions:
#' \pkg{sofa} was built assuming CouchDB version 2 or greater. Some
#' functionality of this package will work with versions < 2, while
#' some may not (mango queries, see [db_query()]). I don't
#' plan to support older CouchDB versions per se.
#' @return An object of class `Cushion`, with variables accessible for
#' host, port, path, transport, user, pwd, and headers. Functions are callable
#' to get headers, and to make the base url sent with all requests.
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
#' # With auth
#' x <- Cushion$new(user = 'sckott', pwd = 'sckott')
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
    #' @field host (character) host
    host = '127.0.0.1',
    #' @field port (integer) port
    port = 5984,
    #' @field path (character) url path, if any
    path = NULL,
    #' @field transport (character) transport schema, (http|https)
    transport = 'http',
    #' @field user (character) username
    user = NULL,
    #' @field pwd (character) password
    pwd = NULL,
    #' @field headers (list) named list of headers
    headers = NULL,

    #' @description Create a new `Cushion` object
    #' @param host (character) A base URL (without the transport), e.g.,
    #' `localhost`, `127.0.0.1`, or `foobar.cloudant.com`
    #' @param port (numeric) Port. Remember that if you don't want a port set,
    #' set this parameter to `NULL`. Default: `5984`
    #' @param path (character) context path that is appended to the end of
    #' the url. e.g., `bar` in `http://foo.com/bar`. Default: `NULL`,
    #' ignored
    #' @param transport (character) http or https. Default: http
    #' @param user,pwd (character) user name, and password. these are used in all
    #' requests. if absent, they are not passed to requests
    #' @param headers A named list of headers. These headers are used in all
    #' requests. To use headers in individual requests and not others, pass
    #' in headers via `...` in a function call.
    #' @return A new `Cushion` object
    initialize = function(host, port, path, transport, user, pwd, headers) {
      if (!missing(host)) self$host <- host
      if (!missing(port)) self$port <- port
      if (!missing(path)) self$path <- path
      if (!missing(transport)) self$transport <- transport
      if (!missing(user)) self$user <- user
      if (!missing(pwd)) self$pwd <- pwd
      if (!missing(user) && !missing(pwd)) {
        private$auth_headers <- crul::auth(user, pwd)
      }
      if (!missing(headers)) self$headers <- headers
    },

    #' @description print method for `Cushion`
    #' @param x self
    #' @param ... ignored
    print = function() {
      cat("<sofa - cushion> ", sep = "\n")
      cat(paste0("  transport: ", self$transport), sep = "\n")
      cat(paste0("  host: ", self$host), sep = "\n")
      cat(paste0("  port: ", self$port), sep = "\n")
      cat(paste0("  path: ", self$path), sep = "\n")
      cat(paste0("  type: ", self$type), sep = "\n")
      cat(paste0("  user: ", self$user), sep = "\n")
      cat(paste0("  pwd: ", if (!is.null(self$pwd)) '<secret>' else ''),
          sep = "\n")
      invisible(self)
    },

    #' @description Ping the CouchDB server
    #' @param ... curl options passed to [crul::verb-GET]
    ping = function(...) {
      sofa_GET(self$make_url(), ...)
    },

    #' @description Construct full base URL from the pieces in the
    #' connection object
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

    #' @description Get list of headers that will be sent with
    #' each request
    get_headers = function() self$headers,
    #' @description Get list of auth values, user and pwd
    get_auth = function() private$auth_headers
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
