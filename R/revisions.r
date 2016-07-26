#' Get document revisions.
#'
#' @export
#' @inheritParams ping
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname Database name
#' @param docid Document ID
#' @param simplify (logical) Simplify to character vector of revision ids. If FALSE, gives back
#' availabilit info too.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("error" %in% names(db_info(x, "sofadb"))) {
#'  db_create(x, dbname = "sofadb")
#' }
#'
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="sofadb", doc1, docid="abeer")
#' doc_create(x, dbname="sofadb", doc1, docid="morebeer", as='json')
#'
#' revisions(x, dbname="sofadb", docid="abeer")
#' revisions(x, dbname="sofadb", docid="abeer", simplify=FALSE)
#' revisions(x, dbname="sofadb", docid="abeer", as='json')
#' revisions(x, dbname="sofadb", docid="abeer", simplify=FALSE, as='json')
#' }
revisions <- function(cushion, dbname, docid, simplify=TRUE, as='list', ...) {
  check_cushion(cushion)
  call_ <- sprintf("%s/%s/%s", cushion$make_url(), dbname, docid)
  tmp <- sofa_GET(call_, as = "list", query = list(revs_info = 'true'), cushion$get_headers(), ...)
  revs <- if (simplify) vapply(tmp$`_revs_info`, "[[", "", "rev") else tmp$`_revs_info`
  if (as == 'json') jsonlite::toJSON(revs) else revs
}
