#' Get uuids.
#'
#' @import httr
#' @export
#' @param cushion A cushion name
#' @param count (numeric) Number of uuids to return. Default: 1
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' uuids()
#' uuids("cloudant")
#' uuids("iriscouch")
#' }

uuids <- function(cushion="localhost", count=1, ...)
{
  cushion <- get_cushion(cushion)
  sofa_GET(paste0(pick_url(cushion), '_uuids'), list(count=count), ...)
}
