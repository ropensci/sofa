#' Create a database.
#'
#' @export
#' @param cushion A cushion name
#' @param dbname Database name
#' @param delifexists If TRUE, delete any database of the same name before creating it.
#'    This is useful for testing. Default is FALSE.
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' db_create(dbname='leothelion')
#' db_list() # see if its there now
#'
#' ## or setting username and password in cushion() call
#' db_create("cloudant", "mustache")
#'
#' ## iriscouch
#' db_create("iriscouch", "beard")
#'
#' ## arbitrary remote couchdb
#' db_create("oceancouch", "beard")
#' }

db_create <- function(cushion="localhost", dbname, delifexists=FALSE, as='list', ...)
{
  if(delifexists & !is.na(match(dbname, db_list()))) {
    db_delete(cushion, dbname, ...)
  }
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    url <- pick_url(cushion)
    sofa_PUT(sprintf("%s%s", url, dbname), as, ...)
  } else {
    if(cushion$type=="localhost"){
      sofa_PUT(sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname), as, ...)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      sofa_PUT(remote_url(cushion, dbname), as, ...)
    }
  }
}
