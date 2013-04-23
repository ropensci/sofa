#' List all databases.
#' 
#' @inheritParams sofa_ping
#' @examples
#' sofa_listdbs()
#' @export
sofa_listdbs <- function(endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/_all_dbs", sep="")
  fromJSON(content(GET(call_)))
}