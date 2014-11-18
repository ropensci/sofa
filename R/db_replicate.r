#' Upload (replicate) a local database to a remote database server, e.g., Cloudant, Iriscouch
#'
#' @export
#' @inheritParams ping
#' @param from Couch to replicate from, Default: localhost
#' @param to Remote service name to upload to. One of cloudant, iriscouch.
#' @param dbname Database name.
#' @param createdb If TRUE, the function creates the db on the remote server before
#'    uploading. The db has to exist before uploading, so either you do it separately
#'    or this fxn can do it for you. Default = FALSE
#' @examples \donttest{
#' # Create a database locally
#' db_list()
#' db_create('hello_earth')
#'
#' # replicate to a remote server
#' db_replicate(to="cloudant", dbname="hello_earth", createdb=TRUE)
#' changes("cloudant", dbname = "hello_earth")
#' doc_create("cloudant", dbname = "hello_earth", doc = '{"language":"python","library":"requests"}')
#' changes("cloudant", dbname = "hello_earth")
#'
#' doc_create("cloudant", dbname = "hello_earth", doc = '{"language":"R"}', docid="R_rules")
#' doc_get("cloudant", dbname = "hello_earth", docid='R_rules')
#'
#' db_delete('cloudant', 'hello_earth')
#' }

db_replicate <- function(from='localhost', to="cloudant", dbname, createdb=FALSE, as='list', ...){
  cushion <- get_cushion(to)
  if(createdb) createdb(cushion, dbname)
  fromcushion <- get_cushion(from)
  if(fromcushion$type=="localhost")
    url <- sprintf('http://localhost:%s/_replicate', fromcushion$port)
  else
    url <- remote_url(fromcushion, endpt = '_replicate')

  if(cushion$type %in% c("cloudant",'iriscouch')){
    message(sprintf("Uploading to %s...", to))
    args <- list(source = unbox(dbname),
                 target = unbox(cloudant_url(cushion, dbname)))
    sofa_POST(url, as, content_type_json(), body=args, encode="json", ...)
  } else stop(paste0(cushion$type, " is not supported yet"))
}
