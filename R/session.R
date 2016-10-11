#' session
#'
#' @export
#' @template all
#' @template return
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' (x <- Cushion$new())
#'
#' session(x)
#' session(x, as = 'json')
#' }
session <- function(cushion, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(file.path(cushion$make_url(), '_session'),
           as = as, cushion$get_headers(), ...)
}
