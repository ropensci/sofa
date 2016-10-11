#' Delete a database.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' # local databasees
#' ## create database first, then delete
#' db_create(x, dbname='newdb')
#' db_delete(x, dbname='newdb')
#'
#' ## with curl info while doing request
#' library('httr')
#' db_create(x, 'newdb')
#' db_delete(x, 'newdb', config = httr::verbose())
#' }
db_delete <- function(cushion, dbname, as = 'list', ...) {
  check_cushion(cushion)
  sofa_DELETE(sprintf("%s/%s", cushion$make_url(), dbname), as, cushion$get_headers(), ...)
}
