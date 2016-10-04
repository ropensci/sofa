#' membership
#'
#' @export
#' @inheritParams ping
#' @param as (character) One of list (default) or json
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' (x <- Cushion$new())
#'
#' membership(x)
#' membership(x, as = 'json')
#' }
membership <- function(cushion, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(file.path(cushion$make_url(), '_membership'),
           as = as, cushion$get_headers(), ...)
}
