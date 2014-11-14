#' Delete a database.
#'
#' @export
#' @param cushion A cushion name
#' @param dbname Database name
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # local databasees
#' ## create database first, then delete
#' createdb('newdb')
#' deletedb('newdb')
#'
#' # cloudant
#' createdb("cloudant", "stuffthings")
#' listdbs("cloudant")
#' deletedb("cloudant", "stuffthings")
#'
#' ## with curl info while doing request
#' library('httr')
#' createdb('newdb')
#' deletedb('newdb', config=verbose())
#' }

deletedb <- function(cushion="localhost", dbname, ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    sofa_DELETE(sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname), ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    sofa_DELETE(remote_url(cushion, dbname), content_type_json(), ...)
  } else stop(paste0(cushion$type, " is not supported yet"))
}
