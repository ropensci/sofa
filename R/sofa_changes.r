#' List changes to a database.
#'
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @examples
#' sofa_changes(dbname="sofadb")
#' sofa_changes(dbname="sofadb", limit=2)
#' @export
sofa_changes <- function(endpoint="http://127.0.0.1", port=5984, dbname, 
                         descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, 
                         include_docs=NULL)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/_changes", sep="")
  args <- compact(list(descending=descending, startkey=startkey,endkey=endkey,
                       limit=limit,include_docs=include_docs))
  out <- GET(call_, query=args)
  stop_for_status(out)
  fromJSON(content(out))
}