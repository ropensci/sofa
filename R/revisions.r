#' Get document revisions.
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name
#' @param docid Document ID
#' @param simplify (logical) Simplify to character vector of revision ids. If FALSE, gives back
#' availabilit info too.
#' @examples \donttest{
#' revisions(dbname="sofadb", docid="a_beer")
#' revisions(dbname="sofadb", docid="a_beer", simplify=FALSE)
#' revisions(dbname="sofadb", docid="a_beer", as='json')
#' revisions(dbname="sofadb", docid="a_beer", simplify=FALSE, as='json')
#' }

revisions <- function(cushion="localhost", dbname, docid, simplify=TRUE, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    tmp <- sofa_GET(sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid), list(revs_info='true'), 'list', ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    tmp <- sofa_GET(file.path(remote_url(cushion, dbname), docid), list(revs_info='true'), 'list', content_type_json(), ...)
  }
  revs <- if(simplify) vapply(tmp$`_revs_info`, "[[", "", "rev") else tmp$`_revs_info`
  if(as=='json') jsonlite::toJSON(revs) else revs
}
