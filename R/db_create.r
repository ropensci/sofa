#' Create a database.
#'
#' @export
#' @param cushion A cushion name
#' @param dbname Database name
#' @param delifexists If TRUE, delete any database of the same name before creating it.
#'    This is useful for testing. Default is FALSE.
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' db_create(dbname='leothelion')
#' db_list() # see if its there now
#'
#' ## or setting username and password in cushion() call
#' db_create("cloudant", "mustache")
#'
#' ## iriscouch
#' db_create("iriscouch", "beard")
#'
#' ## arbitrary remote couchdb
#' db_create("oceancouch", dbname = "beard")
#' }

db_create <- function(cushion, dbname, delifexists=FALSE, as='list', ...) {
  if (delifexists) db_delete(cushion, dbname, ...)
  check_cushion(cushion)
  sofa_PUT(file.path(cushion$make_url(), dbname), as, ...)
}
