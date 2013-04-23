#' Ping the couchdb server.
#' 
#' @param endpoint the endpoint, defaults to localhost (http://127.0.0.1)
#' @param port port to connect to, defaults to 5984
#' @examples
#' sofa_ping()
#' @export
sofa_ping <- function(endpoint="http://127.0.0.1", port=5984)
{
  fromJSON(content(GET(paste(endpoint, port, sep=":"))))
}