#' Delete a database.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user = user, pwd = pwd))
#'
#' # local databasees
#' ## create database first, then delete
#' db_create(x, dbname = "newdb")
#' db_delete(x, dbname = "newdb")
#'
#' ## with curl info while doing request
#' library("crul")
#' db_create(x, "newdb")
#' db_delete(x, "newdb", verbose = TRUE)
#' }
db_delete <- function(cushion, dbname, as = "list", ...) {
  check_cushion(cushion)
  sofa_DELETE(
    sprintf("%s/%s", cushion$make_url(), dbname), as,
    cushion$get_headers(), cushion$get_auth(), ...
  )
}
