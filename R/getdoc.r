#' Get a document from a database.
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name
#' @param docid Document ID
#' @examples \donttest{
#' getdoc(dbname="sofadb", docid="beer")
#' getdoc("cloudant", dbname='gaugesdb_ro', docid='017ba8075b92656bbca20b8ab6fdb21d')
#' getdoc("iriscouch", dbname='helloworld', docid="0c0858b75a81c464a74119ca24000543")
#' }

getdoc <- function(cushion="localhost", dbname, docid, ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    sofa_GET(sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid), NULL, ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    sofa_GET(file.path(remote_url(cushion, dbname), docid), NULL, content_type_json(), ...)
  }
}
