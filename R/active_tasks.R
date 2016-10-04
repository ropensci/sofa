#' active tasks
#'
#' @export
#' @inheritParams ping
#' @param as (character) One of list (default) or json
#' @examples \dontrun{
#' # Create a CouchDB connection client
#' (x <- Cushion$new())
#'
#' active_tasks(x)
#' active_tasks(x, as = 'json')
#' }
active_tasks <- function(cushion, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(file.path(cushion$make_url(), '_active_tasks'),
           as = as, cushion$get_headers(), ...)
}
