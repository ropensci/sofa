#' Create a database.
#' 
#' @inheritParams sofa_ping
#' @examples
#' sofa_createdb(dbname='sofadb')
#' sofa_listdbs() # see if its there now
#' @export
sofa_createdb <- function(endpoint="http://127.0.0.1", port=5984, dbname)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, sep="")
  fromJSON(content(PUT(call_)))
}