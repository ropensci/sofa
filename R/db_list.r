#' List all databases.
#'
#' @export
#' @param cushion A \code{Cushion} object. Required.
#' @param simplify (logical) Simplify to character vector, ignored if \code{as="json"}
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # local databasees
#' (x <- Cushion$new())
#' db_list(x)
#' db_list(x, as = 'json')
#' db_list(x, "cloudant")
#' db_list(x, "iriscouch")
#' db_list(x, "oceancouch")
#' }

db_list <- function(cushion, simplify=TRUE, as='list', ...) {
  check_cushion(cushion)
  tmp <- sofa_GET(sprintf("%s/_all_dbs", cushion$make_url()), as, cushion$get_headers(), ...)
  if (simplify && as == 'list') do.call(c, tmp) else tmp
}
