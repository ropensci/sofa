#' List database info.
#'
#' @export
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname Database name
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' db_info(x, dbname="sofadb")
#' db_info(x, dbname="sofadb", as='json')
#' }
db_info <- function(cushion, dbname, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(sprintf("%s/%s", cushion$make_url(), dbname), as, cushion$get_headers(), ...)
}
