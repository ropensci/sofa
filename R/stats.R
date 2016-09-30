#' Get stats on your Couchdb instance
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param section (character) One of couchdb, httpd_request_methods, or
#' httpd_status_codes. Default is none of them, which returns all sections.
#' @param stat (character) Statistic to return. There are many options.
#'
#' @details Note that if you provide \code{section} you have to provide
#' \code{stat}, or the function drops those variables, and defaults to
#' all statistics.
#'
#' Note that this isn't working with CouchDB v2, not sure why
#'
#' @examples \dontrun{
#' stats(x)
#' stats(x, as = "json")
#'
#' # couchdb stats
#' stats(x, section="couchdb", stat="database_writes")
#' stats(x, section="couchdb", stat = "open_os_files")
#'
#' # request methods
#' stats(x, section="httpd_request_methods", stat="GET")
#' stats(x, section="httpd_request_methods", stat="POST")
#'
#' # request status codes
#' stats(x, section="httpd_status_codes", stat=200)
#' stats(x, section="httpd_status_codes", stat=400)
#' }
stats <- function(cushion, section = NULL, stat = NULL, as = 'list', ...) {
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), "_stats")
  if (!is.null(section) && !is.null(stat)) {
    url <- file.path(url, section, stat)
  }
  sofa_GET(url, as = as, args = NULL, cushion$get_headers(), ...)
}
