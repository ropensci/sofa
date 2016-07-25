#' List database info.
#'
#' @export
#' @param cushion A cushion name
#' @param dbname Database name
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # local databasees
#' db_info(dbname="sofadb")
#' db_info(dbname="sofadb", as='json')
#'
#' # a database on cloudant or iriscouch
#' db_info("cloudant", "gaugesdb_ro")
#' db_info("iriscouch", "helloworld")
#'
#' ## arbitrary remote couchdb
#' db_info("oceancouch", "beard")
#' }
db_info <- function(cushion, dbname, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(sprintf("%s/%s", cushion$make_url(), dbname), as, ...)
}
