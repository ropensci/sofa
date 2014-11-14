#' Get a document from a database.
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name
#' @param docid Document ID
#' @param attachments (logical) Whether to include _attachments field.
#' @param deleted (logical) Whether to include _deleted field.
#' @param revs (logical) Whether to include _revisions field.
#' @param revs_info (logical) Whether to include _revs_info field.
#' @param conflicts (logical) Whether to include _conflicts field.
#' @param deleted_conflicts (logical) Whether to include _deleted_conflicts field.
#' @param local_seq (logical) Whether to include _local_seq field.
#' @examples \donttest{
#' getdoc(dbname="sofadb", docid="a_beer")
#' getdoc(dbname="sofadb", docid="a_beer", as='json')
#' getdoc(dbname="sofadb", docid="a_beer", revs=TRUE)
#' getdoc(dbname="sofadb", docid="a_beer", revs=TRUE, local_seq=TRUE)
#' getdoc("cloudant", dbname='gaugesdb_ro', docid='017ba8075b92656bbca20b8ab6fdb21d')
#' getdoc("iriscouch", dbname='helloworld', docid="0c0858b75a81c464a74119ca24000543")
#' }

getdoc <- function(cushion="localhost", dbname, docid, attachments=FALSE, deleted=FALSE,
  revs=FALSE, revs_info=FALSE, conflicts=FALSE, deleted_conflicts=FALSE,
  local_seq=FALSE, as='list', ...)
{
  cushion <- get_cushion(cushion)
  args <- sc(list(attachments=asl(attachments), deleted=asl(deleted), revs=asl(revs),
                  revs_info=asl(revs_info), conflicts=asl(conflicts),
                  deleted_conflicts=asl(deleted_conflicts), local_seq=asl(local_seq)))
  if(cushion$type=="localhost"){
    sofa_GET(sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid), args, as, ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    sofa_GET(file.path(remote_url(cushion, dbname), docid), args, as, content_type_json(), ...)
  }
}
