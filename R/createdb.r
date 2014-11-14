#' Create a database.
#'
#' @export
#' @param cushion A cushion name
#' @param dbname Database name
#' @param delifexists If TRUE, delete any database of the same name before creating it.
#'    This is useful for testing. Default is FALSE.
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' createdb(dbname='leothelion')
#' listdbs() # see if its there now
#'
#' ## or setting username and password in cushion() call
#' createdb("cloudant", "mustache")
#'
#' ## iriscouch
#' createdb("iriscouch", "beard")
#' }

createdb <- function(cushion="localhost", dbname, delifexists=FALSE, ...)
{
  if(delifexists) deletedb(cushion, dbname, ...)
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    sofa_PUT(sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname), ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    sofa_PUT(remote_url(cushion, dbname), content_type_json(), ...)
  }
}
