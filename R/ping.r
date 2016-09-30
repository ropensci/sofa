#' Ping a couchdb server
#'
#' @export
#' @param cushion A \code{Cushion} object. Required.
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
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
