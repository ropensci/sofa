#' Update a document.
#'
#' @export
#' @inheritParams ping
#' @param dbname (character) Database name. Required.
#' @param doc (character) Document content. Required.
#' @param docid (character) Document ID. Required.
#' @param rev (character) Revision id. Required.
#' @details Internally, this function adds in the docid and revision id,
#' required to do a document update
#' @examples \dontrun{
#' (x <- Cushion$new(user = 'jane', pwd = 'foobar'))
#'
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, dbname='sofadb')
#'
#' doc1 <- '{"name":"drink","beer":"IPA"}'
#' doc_create(x, dbname="sofadb", doc=doc1, docid="b_beer")
#' doc_get(x, dbname = "sofadb", docid = "b_beer")
#' revs <- revisions(x, dbname = "sofadb", docid = "b_beer")
#' doc2 <- '{"name":"drink","beer":"IPA","note":"yummy","note2":"yay"}'
#' doc_update(x, dbname="sofadb", doc=doc2, docid="b_beer", rev=revs[1])
#' revisions(x, dbname = "sofadb", docid = "b_beer")
#' }
doc_update <- function(cushion, dbname, doc, docid, rev, as = 'list', ...) {
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), dbname, docid)
  doc2 <- sub("^\\{", sprintf('{"_id":"%s", "_rev":"%s",', docid, rev), check_inputs(doc))
  sofa_PUT(url, as, body = doc2, encode = "json", cushion$get_headers(), ...)
}
