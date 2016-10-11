#' List database info.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @examples \dontrun{
#' (x <- Cushion$new())
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
  sofa_GET(sprintf("%s/%s", cushion$make_url(), dbname), as, cushion$get_headers(), ...)
}
