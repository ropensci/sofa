#' Get a document from a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name
#' @param docid Document ID
#' @param rev Revision id of the document to get. If NULL, gets current revision
#' @param attachments (logical) Whether to include _attachments field.
#' @param deleted (logical) Whether to include _deleted field.
#' @param revs (logical) Whether to include _revisions field.
#' @param revs_info (logical) Whether to include _revs_info field.
#' @param conflicts (logical) Whether to include _conflicts field.
#' @param deleted_conflicts (logical) Whether to include _deleted_conflicts field.
#' @param local_seq (logical) Whether to include _local_seq field.
#' @examples \dontrun{
#' (x <- Cushion$new(user = 'jane', pwd = 'foobar'))
#'
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, dbname="sofadb")
#'
#' # create a document
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="sofadb", doc1, docid="abeer")
#'
#' doc_get(x, dbname="sofadb", docid="abeer")
#' revs <- revisions(x, dbname="sofadb", docid="abeer")
#' doc_get(x, dbname="sofadb", docid="abeer", rev=revs[1])
#' doc_get(x, dbname="sofadb", docid="abeer", rev=revs[2])
#' doc_get(x, dbname="sofadb", docid="abeer", as='json')
#' doc_get(x, dbname="sofadb", docid="abeer", revs=TRUE)
#' doc_get(x, dbname="sofadb", docid="abeer", revs=TRUE, local_seq=TRUE)
#' }
doc_get <- function(cushion, dbname, docid, rev=NULL, attachments=FALSE, deleted=FALSE,
  revs=FALSE, revs_info=FALSE, conflicts=FALSE, deleted_conflicts=FALSE,
  local_seq=FALSE, as='list', ...) {

  check_cushion(cushion)
  args <- sc(list(
    rev = rev, attachments = asl(attachments), deleted = asl(deleted), revs = asl(revs),
    revs_info = asl(revs_info), conflicts = asl(conflicts),
    deleted_conflicts = asl(deleted_conflicts), local_seq = asl(local_seq)
  ))
  url <- file.path(cushion$make_url(), dbname, docid)
  sofa_GET(url, as, query = args, ...)
}
