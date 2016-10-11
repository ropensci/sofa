#' Ping a couchdb server
#'
#' @export
#' @template all
#' @template return
#' @examples \dontrun{
#' # initialize a couchdb connection
#' (x <- Cushion$new())
#'
#' ping(x)
#' ping(x, as = "json")
#' }
ping <- function(cushion, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(cushion$make_url(), as = as, args = NULL, cushion$get_headers(), ...)
}
