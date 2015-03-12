#' Restart your Couchdb instance
#'
#' @export
#' @inheritParams ping
#' @examples \dontrun{
#' restart()
#' }
restart <- function(cushion = "localhost", as = 'list', ...) {
  cushion <- get_cushion(cushion)
  sofa_POST(paste0(pick_url(cushion), "_restart"), as=as)
}
