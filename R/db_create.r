#' Create a database.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @param delifexists If `TRUE`, delete any database of the same name before
#' creating it. This is useful for testing. Default: `FALSE`
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' if ("leothelion" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="leothelion"))
#' }
#' db_create(x, dbname='leothelion')
#'
#' ## see if its there now
#' db_list(x)
#' }
db_create <- function(cushion, dbname, delifexists=FALSE, as='list', ...) {
  if (delifexists) db_delete(cushion, dbname, ...)
  check_cushion(cushion)
  sofa_PUT(file.path(cushion$make_url(), dbname), as,
           headers = cushion$get_headers(), auth = cushion$get_auth(), ...)
}
