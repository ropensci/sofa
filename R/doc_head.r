#' Get header info for a document.
#'
#' @export
#' @inheritParams ping
#' @param dbname (character) Database name. Required.
#' @param docid (character) Document ID. Required.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' # create a database
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, dbname='sofadb')
#'
#' # create a document
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="sofadb", doc1, docid="abeer")
#'
#' # run doc_head
#' doc_head(x, dbname="sofadb", docid="abeer")
#' doc_head(x, dbname="sofadb", docid="abeer", as='json')
#' }
doc_head <- function(cushion, dbname, docid, as = 'list', ...) {
  check_cushion(cushion)
  out <- HEAD(
    file.path(cushion$make_url(), dbname, docid),
    cushion$get_headers(),
    ...)
  stop_status(out)
  if (as == 'list') out$all_headers else jsonlite::toJSON(out$all_header)
}
