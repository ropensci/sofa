#' Get a document from a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name
#' @param docid Document ID
#' @examples \donttest{
#' getdoc(dbname="sofadb", docid="beer")
#' }

getdoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid, ...)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
  sofa_GET(call_, ...)
}
