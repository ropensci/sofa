#' List all docs in a given database.
#'
#' @export
#' @inheritParams ping
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname Database name. (charcter)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs (logical) If \code{TRUE}, returns docs themselves,
#' in addition to IDs. Default: \code{FALSE}
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @return JSON as a character string or a list
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' db_create(x, dbname='leothelion')
#' bulk_create(x, mtcars, dbname="leothelion")
#'
#' db_alldocs(x, dbname="leothelion")
#' db_alldocs(x, dbname="leothelion", as='json')
#' db_alldocs(x, dbname="leothelion", limit=2)
#' db_alldocs(x, dbname="leothelion", limit=2, include_docs=TRUE)
#'
#' # curl options
#' library('httr')
#' res <- db_alldocs(x, dbname="leothelion", config=verbose())
#' }

db_alldocs <- function(cushion, dbname, descending=NULL, startkey=NULL,
  endkey=NULL, limit=NULL, include_docs=FALSE, as='list', ...) {

  check_cushion(cushion)
  check_if(include_docs, "logical")
  args <- sc(list(
    descending = descending, startkey = startkey, endkey = endkey,
    limit = limit, include_docs = asl(include_docs)))
  call_ <- sprintf("%s/%s/_all_docs", cushion$make_url(), dbname)
  sofa_GET(call_, as, query = args, cushion$get_headers(), ...)
}
