#' Upload (replicate) a local database to a remote database server,
#' e.g., Cloudant, Iriscouch
#'
#' @export
#' @template return
#' @param from Couch to replicate from. An object of class [Cushion].
#' Required.
#' @param to Remote couch to replicate to. An object of class [Cushion].
#' Required.
#' @param dbname (character) Database name. Required.
#' @param createdb If `TRUE`, the function creates the db on the remote
#' server before uploading. The db has to exist before uploading, so either
#' you do it separately or this fxn can do it for you. Default: `FALSE`
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to [crul::HttpClient]
#' @examples \dontrun{
#' ## create a connection
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' # Create a database locally
#' db_list(x)
#' if ("hello_earth" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="hello_earth"))
#' }
#' db_create(x, 'hello_earth')
#'
#' ## replicate to a remote server
#' z <- Cushion$new(host = "ropensci.cloudant.com", transport = 'https',
#'   port = NULL, user = 'ropensci', pwd = Sys.getenv('CLOUDANT_PWD'))
#'
#' ## do the replication
#' db_replicate(x, z, dbname = "hello_earth")
#'
#' ## check changes on the remote
#' db_list(z)
#' db_changes(z, dbname = "hello_earth")
#'
#' ## make some changes on the remote
#' doc_create(z, dbname = "hello_earth",
#'   '{"language":"python","library":"requests"}', 'stuff')
#' changes(z, dbname = "hello_earth")
#'
#' ## create another document, and try to get it
#' doc_create(z, dbname = "hello_earth", doc = '{"language":"R"}',
#'   docid="R_rules")
#' doc_get(z, dbname = "hello_earth", docid='R_rules')
#'
#' ## cleanup - delete the database
#' db_delete(z, 'hello_earth')
#' }
db_replicate <- function(from, to, dbname, createdb = FALSE, as = 'list', ...) {
  check_cushion(to)
  check_cushion(from)
  if (createdb) db_create(to, dbname)
  fromurl <- file.path(from$make_url(), '_replicate')
  tourl <- file.path(to$make_url(), dbname)
  args <- list(source = unbox(dbname), target = unbox(cloudant_url(to, dbname)))
  message("Uploading ...")
  sofa_POST(fromurl, as, body = args, encode = "json",
            from$get_headers(), from$get_auth(), ...)
}
