#' Ping a couchdb server.
#'
#' @import httr
#' @export
#' @param cushion A \code{Cushion} object. Required.
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' ping()
#' ping("cloudant")
#' ping("iriscouch")
#' ping("oceancouch")
#' }

ping <- function(cushion="localhost", as='list', ...)
{
  cushion <- get_cushion(cushion)
  sofa_GET(pick_url(cushion), as=as, args=NULL, ...)
}
