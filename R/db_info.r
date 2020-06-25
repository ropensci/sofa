#' List database info.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, dbname='sofadb')
#'
#' db_info(x, dbname="sofadb")
#' db_info(x, dbname="sofadb", as='json')
#' }
db_info <- function(cushion, dbname, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(sprintf("%s/%s", cushion$make_url(), dbname), as,
           headers = cushion$get_headers(), auth = cushion$get_auth(), ...)
}
