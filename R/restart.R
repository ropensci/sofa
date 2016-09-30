#' Restart your Couchdb instance
#'
#' @export
#' @inheritParams ping
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' # restart(x)
#' }
restart <- function(cushion = "localhost", as = 'list', ...) {
  check_cushion(cushion)
  sofa_POST(file.path(cushion$make_url(), "_restart"),
            as = as, cushion$get_headers(), ...)
}
