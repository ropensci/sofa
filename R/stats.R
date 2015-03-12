#' Get stats on your Couchdb instance
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param section (character) One of couchdb, httpd_request_methods, or httpd_status_codes.
#' Default is none of them, which returns all sections.
#' @param stat (character) Statistic to return. There are many options.
#'
#' @details Note that if you provide \code{section} you have to provide \code{stat}, or
#' the function drops those variables, and defaults to all statistics.
#'
#' @examples \dontrun{
#' stats()
#' stats(as = "json")
#'
#' # couchdb stats
#' stats(section="couchdb", stat="database_writes")
#' stats(section="couchdb", stat = "open_os_files")
#'
#' # request methods
#' stats(section="httpd_request_methods", stat="GET")
#' stats(section="httpd_request_methods", stat="POST")
#'
#' # request status codes
#' stats(section="httpd_status_codes", stat=200)
#' stats(section="httpd_status_codes", stat=400)
#' }
stats <- function(cushion = "localhost", section = NULL, stat = NULL, as = 'list', ...) {
  cushion <- get_cushion(cushion)
  url <- paste0(pick_url(cushion), "_stats")
  if(!is.null(section) && !is.null(stat)) {
    url <- file.path(url, section, stat)
  }
  sofa_GET(url, as=as, args=NULL, ...)
}
