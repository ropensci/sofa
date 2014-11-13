#' Stop indexing a CouchDB database using Elasticsearch.
#'
#' @import httr
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @details The function returns a message 'elastic river stopped'. This function stops
#'    elasticsearch from indexing the database in the dbname parameter. You may want 
#'    stop indexing e.g., if you started indexing a database that you didn't mean to 
#'    start indexing.
#' @examples \donttest{
#' elastic_stop(dbname = "ggggg")
#' }
#' @export
elastic_stop <- function(dbname, endpoint="http://localhost", port=9200)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/_river/", dbname, sep="")
  DELETE(url = call_)
  message("elastic river stopped")
}