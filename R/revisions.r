#' Get document revisions.
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name
#' @param docid Document ID
#' @examples \donttest{
#' revisions(dbname="sofadb", docid="a_beer")
#' revisions(dbname="sofadb", docid="a_beer", as='json')
#' }

revisions <- function(cushion="localhost", dbname, docid, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    tmp <- sofa_GET(sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid), list(revs_info='true'), 'list', ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    tmp <- sofa_GET(file.path(remote_url(cushion, dbname), docid), list(revs_info='true'), 'list', content_type_json(), ...)
  }
  revs <- vapply(tmp$`_revs_info`, "[[", "", "rev")
  if(as=='json') jsonlite::toJSON(revs) else revs
}
