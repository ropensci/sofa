#' Get a document from a database.
#'
#' @export
#' @inheritParams sofa_ping
#' @param dbname Database name
#' @param docid Document ID
#' @examples \donttest{
#' sofa_getdoc(dbname="sofadb", docid="beer")
#' }
sofa_getdoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid, ...)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
  sofa_GET(call_, ...)
}
