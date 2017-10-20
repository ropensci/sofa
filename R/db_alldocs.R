#' List all docs in a given database.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name. (character)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs (logical) If `TRUE`, returns docs themselves,
#' in addition to IDs. Default: `FALSE`
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
#' res <- db_alldocs(x, dbname="leothelion", verbose = TRUE)
#' }

db_alldocs <- function(cushion, dbname, descending=NULL, startkey=NULL,
  endkey=NULL, limit=NULL, include_docs=FALSE, as='list', ...) {

  check_cushion(cushion)
  check_if(include_docs, "logical")
  args <- sc(list(
    descending = descending, startkey = startkey, endkey = endkey,
    limit = limit, include_docs = asl(include_docs)))
  call_ <- sprintf("%s/%s/_all_docs", cushion$make_url(), dbname)
  sofa_GET(call_, as, query = args, cushion$get_headers(),
           cushion$get_auth(), ...)
}
