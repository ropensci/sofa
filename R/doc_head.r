#' Get header info for a document
#'
#' @export
#' @param cushion A \code{\link{Cushion}} object. Required.
#' @param dbname (character) Database name. Required.
#' @param docid (character) Document ID. Required.
#' @param ... Curl args passed on to \code{\link[crul]{HttpClient}}
#' @template return
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
doc_head <- function(cushion, dbname, docid, ...) {
  check_cushion(cushion)
  sofa_HEAD(file.path(cushion$make_url(), dbname, docid),
            cushion$get_headers(), cushion$get_auth(), ...)
}
