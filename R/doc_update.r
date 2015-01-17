#' Update a document.
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name3
#' @param doc Document content
#' @param docid Document ID
#' @param rev Revision id.
#' @details Internally, this function adds in the docid and revision id, required to do a
#' document update.
#' @examples \donttest{
#' doc1 <- '{"name":"drink","beer":"IPA"}'
#' doc_create(dbname="sofadb", doc=doc1, docid="b_beer")
#' doc_get(dbname = "sofadb", docid = "b_beer")
#' revs <- revisions(dbname = "sofadb", docid = "b_beer")
#' doc2 <- '{"name":"drink","beer":"IPA","note":"yummy","note2":"yay"}'
#' doc_update(dbname="sofadb", doc=doc2, docid="b_beer", rev=revs[1])
#' revisions(dbname = "sofadb", docid = "b_beer")
#' }

doc_update <- function(cushion="localhost", dbname, doc, docid, rev, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    call_ <- remote_url(cushion, dbname)
  }
  doc2 <- sub("^\\{", sprintf('{"_id":"%s", "_rev":"%s",', docid, rev), check_inputs(doc))
  sofa_PUT(paste0(call_, "/", docid), as, body=doc2, encode="json", ...)
}
