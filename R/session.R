#' session
#'
#' @export
#' @template all
#' @template return
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user = user, pwd = pwd))
#'
#' session(x)
#' session(x, as = "json")
#' }
session <- function(cushion, as = "list", ...) {
  check_cushion(cushion)
  sofa_GET(file.path(cushion$make_url(), "_session"),
    as = as, headers = cushion$get_headers(),
    auth = cushion$get_auth(), ...
  )
}
