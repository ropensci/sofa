#' Just get header info on a document
#'
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples
#' sofa_head(dbname="sofadb", docid="dudesbeer")
#' @export
sofa_head <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
  out <- HEAD(call_)
  stop_for_status(out)
  out$headers
}
