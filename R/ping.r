#' Ping a CouchDB server
#'
#' @export
#' @template all
#' @template return
#' @examples \dontrun{
#' # initialize a CouchDB connection
#' (x <- Cushion$new())
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
