#' Get uuids.
#'
#' @export
#' @template all
#' @template return
#' @param count (numeric) Number of uuids to return. Default: 1
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' uuids(x)
#' uuids(x, as = 'json')
#' }
uuids <- function(cushion, count = 1, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(file.path(cushion$make_url(), '_uuids'),
    as = as, query = list(count = count), headers = cushion$get_headers(),
    auth = cushion$get_auth(), ...)
}
