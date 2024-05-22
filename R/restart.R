#' Restart your Couchdb instance
#'
#' @export
#' @template all
#' @template return
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user = user, pwd = pwd))
#'
#' # restart(x)
#' }
restart <- function(cushion = "localhost", as = "list", ...) {
  check_cushion(cushion)
  sofa_POST(file.path(cushion$make_url(), "_restart"),
    as = as, cushion$get_headers(), cushion$get_auth(), ...
  )
}
