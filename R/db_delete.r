#' Delete a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' (x <- Cushion$new(user = 'jane', pwd = 'foobar'))
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
