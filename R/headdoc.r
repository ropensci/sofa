#' Get header info for a document.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \donttest{
#' headdoc(dbname="sofadb", docid="a_beer")
#' headdoc(dbname="sofadb", docid="a_beer", as='json')
#' headdoc("cloudant", dbname="animaldb", docid="badger")
#' headdoc("iriscouch", dbname="helloworld", docid="ggg")
#' }

headdoc <- function(cushion="localhost", dbname, docid, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    call_ <- remote_url(cushion, dbname)
  }
  out <- HEAD(call_, ...)
  stop_for_status(out)
  if(as=='list') out$all_headers else jsonlite::toJSON(out$all_header)
}
