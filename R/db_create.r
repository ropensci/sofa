#' Create a database.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @param delifexists If TRUE, delete any database of the same name before creating it.
#'    This is useful for testing. Default is FALSE.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("leothelion" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="leothelion"))
#' }
#' db_create(x, dbname='leothelion')
#'
#' ## see if its there now
#' db_list(x)
#' }
db_create <- function(cushion, dbname, delifexists=FALSE, as='list', ...) {
  if (delifexists) db_delete(cushion, dbname, ...)
  check_cushion(cushion)
  sofa_PUT(file.path(cushion$make_url(), dbname), as, cushion$get_headers(), ...)
}
