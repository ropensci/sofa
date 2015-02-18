#' Delete a database.
#'
#' @export
#' @param cushion A cushion name
#' @param dbname Database name
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # local databasees
#' ## create database first, then delete
#' db_create(dbname='newdb')
#' db_delete(dbname='newdb')
#'
#' # cloudant
#' db_create("cloudant", "stuffthings")
#' listdbs("cloudant")
#' db_delete("cloudant", "stuffthings")
#'
#' ## with curl info while doing request
#' library('httr')
#' db_create('newdb')
#' db_delete('newdb', config=verbose())
#'
#' ## arbitrary remote couchdb
#' db_delete("oceancouch", "beard")
#' }

db_delete <- function(cushion="localhost", dbname, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    url <- pick_url(cushion)
    sofa_DELETE(sprintf("%s%s", url, dbname), as, ...)
  } else {
    if(cushion$type=="localhost"){
      sofa_DELETE(sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname), as, ...)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      sofa_DELETE(remote_url(cushion, dbname), as, content_type_json(), ...)
    }
  }
}
