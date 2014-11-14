#' Ping a couchdb server.
#'
#' @import httr
#' @export
#' @param cushion A cushion name
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' ping()
#' ping("cloudant")
#' ping("iriscouch")
#' }

ping <- function(cushion="localhost", ...)
{
  cushion <- get_cushion(cushion)
  sofa_GET(pick_url(cushion), args=NULL, ...)
}
