#' Delete a document in a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' # create a database
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, dbname='sofadb')
#'
#' doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' doc_create(x, dbname="sofadb", doc=doc3, docid="newnewxml")
#' doc_delete(x, dbname="sofadb", docid="newnewxml")
#' doc_delete(x, dbname="sofadb", docid="newnewxml")
#'
#' # wrong docid name
#' doc_create(x, dbname="sofadb", doc=doc3, docid="newxml")
#' doc_delete(x, dbname="sofadb", docid="wrongname")
#' }
doc_delete <- function(cushion, dbname, docid, as = 'list', ...) {
  revget <- doc_get(cushion, dbname, docid)[["_rev"]]
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), dbname, docid)
  sofa_DELETE(url, as, query = list(rev = revget), cushion$get_headers(), ...)
}
