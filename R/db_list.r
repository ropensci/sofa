#' List all databases.
#'
#' @export
#' @template all
#' @template return
#' @param simplify (logical) Simplify to character vector, ignored
#' if `as="json"`
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' db_list(x)
#' db_list(x, as = 'json')
#' }
db_list <- function(cushion, simplify=TRUE, as='list', ...) {
  check_cushion(cushion)
  tmp <- sofa_GET(sprintf("%s/_all_dbs", cushion$make_url()), as,
                  headers = cushion$get_headers(),
                  auth = cushion$get_auth(), ...)
  if (simplify && as == 'list') do.call(c, tmp) else tmp
}
