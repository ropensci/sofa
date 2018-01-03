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
#' @param disk write to disk or not. By default, data is in the R session;
#' if you give a file path, we'll write data to disk and you'll get back
#' the file path. by default, we save in the R session
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
#' 
#' # write data to disk - useful when data is very large
#' ## create omdb dataset first
#' file <- system.file("examples/omdb.json", package = "sofa")
#' strs <- readLines(file)
#' if ("omdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="omdb"))
#' }
#' db_create(x, dbname='omdb')
#' invisible(db_bulk_create(x, "omdb", strs))
#'
#' ## get all docs, writing them to disk
#' res <- db_alldocs(x, dbname="omdb", disk = (f <- tempfile(fileext=".json")))
#' res
#' readLines(res, n = 10)
#' }

db_alldocs <- function(cushion, dbname, descending=NULL, startkey=NULL,
  endkey=NULL, limit=NULL, include_docs=FALSE, as='list', 
  disk = NULL, ...) {

  check_cushion(cushion)
  check_if(include_docs, "logical")
  args <- sc(list(
    descending = descending, startkey = startkey, endkey = endkey,
    limit = limit, include_docs = asl(include_docs)))
  call_ <- sprintf("%s/%s/_all_docs", cushion$make_url(), dbname)
  if (is.null(disk)) {
    sofa_GET(call_, as, query = args, cushion$get_headers(),
           cushion$get_auth(), ...)
  } else {
    sofa_GET_disk(call_, as, query = args, cushion$get_headers(),
           cushion$get_auth(), disk, ...)
  }
}
