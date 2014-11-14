#' Get header info for a document.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \donttest{
#' sf_head(dbname="sofadb", docid="beer")
#' sf_head("cloudant", dbname="animaldb", docid="badger")
#' sf_head("iriscouch", dbname="helloworld", docid="ggg")
#' }
sf_head <- function(cushion="localhost", dbname, docid, ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    call_ <- remote_url(cushion, dbname)
  }
  out <- HEAD(call_, ...)
  stop_for_status(out)
  out$all_headers
}
