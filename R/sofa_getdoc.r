#' Get a document from a database.
#' 
#' @inheritParams sofa_ping
#' @param dbname Database name
#' @param docid Document ID
#' @examples
#' sofa_getdoc(dbname="twitter_db", docid="9f6950f1ee18ed0f0a2c529c30003ab0")
#' @export
sofa_getdoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
  fromJSON(content(GET(call_), as="text"))
}