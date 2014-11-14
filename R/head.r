#' Get header info for a document.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \donttest{
#' sf_head(dbname="sofadb", docid="a_beer")
#' sf_head(dbname="sofadb", docid="a_beer", as='json')
#' sf_head("cloudant", dbname="animaldb", docid="badger")
#' sf_head("iriscouch", dbname="helloworld", docid="ggg")
#' }
sf_head <- function(cushion="localhost", dbname, docid, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    call_ <- remote_url(cushion, dbname)
  }
  out <- HEAD(call_, ...)
  stop_for_status(out)
  if(as=='lis') out$all_headers else jsonlite::toJSON(out$all_header)
}
