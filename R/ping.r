#' Ping a couchdb server.
#'
#' @import httr
#' @export
#' @param cushion A cushion name
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' ping()
#' ping("cloudant")
#' ping("iriscouch")
#' }

ping <- function(cushion="localhost", as='list', ...)
{
  cushion <- get_cushion(cushion)
  sofa_GET(pick_url(cushion), args=NULL, as=as, ...)
}
