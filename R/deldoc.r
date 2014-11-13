#' Delete a document in a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \donttest{
#' doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' writedoc(dbname="sofadb", doc=doc3, docid="newxml")
#' deldoc(dbname="sofadb", docid="newxml")
#'
#' # wrong docid name
#' writedoc(dbname="sofadb", doc=doc3, docid="newxml")
#' deldoc(dbname="sofadb", docid="wrongname")
#' }
deldoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid, ...)
{
  revget <- getdoc(dbname=dbname, docid=docid)[["_rev"]]
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, "?rev=", revget, sep="")
  sofa_DELETE(call_, ...)
}
