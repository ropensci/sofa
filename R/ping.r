#' Ping a CouchDB server
#'
#' @export
#' @template all
#' @template return
#' @examples \dontrun{
#' # initialize a CouchDB connection
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' # call ping on the cushion object, or pass the cushion to ping()
#' x$ping()
#' ping(x)
#' ping(x, as = "json")
#' }
ping <- function(cushion, as = 'list', ...) {
  check_cushion(cushion)
  cushion$ping(as, ...)
}
