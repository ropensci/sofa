#' Get uuids.
#'
#' @import httr
#' @export
#' @param cushion A cushion name
#' @param count (numeric) Number of uuids to return. Default: 1
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' uuids()
#' uuids(as = 'json')
#' uuids("cloudant")
#' uuids("iriscouch")
#' uuids("oceancouch")
#' }

uuids <- function(cushion="localhost", count=1, as='list', ...)
{
  cushion <- get_cushion(cushion)
  sofa_GET(paste0(pick_url(cushion), '_uuids'), as=as, query=list(count=count), ...)
}
