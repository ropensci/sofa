#' List all databases.
#'
#' @export
#' @param cushion A cushion name
#' @param simplify (logical) Simplify to character vector, ignored if \code{as="json"}
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # local databasees
#' db_list()
#' db_list(as='json')
#' db_list("cloudant")
#' db_list("iriscouch")
#' db_list("oceancouch")
#' }

db_list <- function(cushion, simplify=TRUE, as='list', ...) {
  check_cushion(cushion)
  tmp <- sofa_GET(sprintf("%s/_all_dbs", cushion$make_url()), as, ...)
  if (simplify && as == 'list') do.call(c, tmp) else tmp
}
