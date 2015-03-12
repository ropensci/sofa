#' Get header info for a document.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \dontrun{
#' doc_head(dbname="sofadb", docid="a_beer")
#' doc_head(dbname="sofadb", docid="a_beer", as='json')
#' doc_head("cloudant", dbname="animaldb", docid="badger")
#' doc_head("iriscouch", dbname="helloworld", docid="ggg")
#' doc_head("oceancouch", dbname="beard", docid="goodbeers")
#' }

doc_head <- function(cushion="localhost", dbname, docid, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    call_ <- sprintf("%s%s/%s", pick_url(cushion), dbname, docid)
  } else {
    if(cushion$type=="localhost"){
      call_ <- sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      call_ <- remote_url(cushion, dbname)
    }
  }
  out <- HEAD(call_, ...)
  stop_for_status(out)
  if(as=='list') out$all_headers else jsonlite::toJSON(out$all_header)
}
