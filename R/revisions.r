#' Get document revisions.
#'
#' @export
#' @inheritParams ping
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname Database name
#' @param docid Document ID
#' @param simplify (logical) Simplify to character vector of revision ids.
#' If \code{FALSE}, gives back availabilit info too. Default: \code{TRUE}
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("sofa" %in% db_list(x)) {
#'  db_delete(x, dbname = "sofadb")
#' }
#' db_create(x, dbname = "sofadb")
#'
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="sofadb", doc1, docid="abeer")
#' doc_create(x, dbname="sofadb", doc1, docid="morebeer", as='json')
#'
#' db_revisions(x, dbname="sofadb", docid="abeer")
#' db_revisions(x, dbname="sofadb", docid="abeer", simplify=FALSE)
#' db_revisions(x, dbname="sofadb", docid="abeer", as='json')
#' db_revisions(x, dbname="sofadb", docid="abeer", simplify=FALSE, as='json')
#' }
db_revisions <- function(cushion, dbname, docid, simplify=TRUE, as='list', ...) {
  check_cushion(cushion)
  call_ <- sprintf("%s/%s/%s", cushion$make_url(), dbname, docid)
  tmp <- sofa_GET(call_, as = "list", query = list(revs_info = 'true'),
                  cushion$get_headers(), ...)
  revs <- if (simplify) vapply(tmp$`_revs_info`, "[[", "", "rev") else tmp$`_revs_info`
  if (as == 'json') jsonlite::toJSON(revs) else revs
}
