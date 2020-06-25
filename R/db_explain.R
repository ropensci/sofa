#' Explain API
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @param query (character) instead of using the other parameters, you can
#' compose one R list or json blob here
#' @param selector (json) - JSON object describing criteria used to select
#' documents. More information provided in the section on selector syntax.
#' See the `query_tutorial` in this package, and the selectors docs
#' <http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-selectors>
#' @param limit (number) - Maximum number of results returned. Default: 25
#' Optional
#' @param skip (number) - Skip the first 'n' results, where 'n' is the value
#' specified. Optional
#' @param sort (json) - JSON array following sort syntax. Optional.
#' See <http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-sort>
#' For some reason, sort doesn't work often, not sure why.
#' @param fields (json) - JSON array specifying which fields of each object
#' should be returned. If it is omitted, the entire object is returned. More
#' information provided in the section on filtering fields. Optional
#' See <http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-filter>
#' @param use_index (json) - Instruct a query to use a specific index.
#' Specified either as `<design_document>` or `["<design_document>",
#' "<index_name>"]`. Optional
#' @examples \dontrun{
#' ## create a connection
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' file <- system.file("examples/omdb.json", package = "sofa")
#' strs <- readLines(file)
#'
#' ## create a database
#' if ("omdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="omdb"))
#' }
#' db_create(x, dbname='omdb')
#'
#' ## add some documents
#' invisible(db_bulk_create(x, "omdb", strs))
#'
#' ## query all in one json blob
#' db_explain(x, dbname = "omdb", query = '{
#'   "selector": {
#'     "_id": {
#'       "$gt": null
#'     }
#'   }
#' }')
#' }
db_explain <- function(cushion, dbname, query = NULL, selector = NULL,
  limit = NULL, skip = NULL, sort = NULL, fields = NULL, use_index = NULL,
  as = 'list', ...) {

  check_cushion(cushion)
  if (is.null(query)) {
    query <- sc(list(
      selector = selector, limit = unbox(limit), skip = skip,
      sort = sort, fields = fields, use_index = use_index
    ))
  }
  sofa_POST(file.path(cushion$make_url(), dbname, "_explain"), as,
            body = query, encode = "json",
            headers = cushion$get_headers(), auth = cushion$get_auth(), ...)
}
