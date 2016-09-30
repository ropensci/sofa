#' Query a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name
#' @param query (character) instead of using the other parameters, you can
#' compose one R list or json blob here
#' @param selector (json) - JSON object describing criteria used to select
#' documents. More information provided in the section on selector syntax.
#' See
#' \url{http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-selectors}
#' @param limit (number) - Maximum number of results returned. Default is 25.
#' Optional
#' @param skip (number) - Skip the first 'n' results, where 'n' is the value
#' specified. Optional
#' @param sort (json) - JSON array following sort syntax. Optional.
#' See \url{http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-sort}
#' @param fields (json) - JSON array specifying which fields of each object
#' should be returned. If it is omitted, the entire object is returned. More
#' information provided in the section on filtering fields. Optional
#' See \url{http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-filter}
#' @param use_index (json) - Instruct a query to use a specific index.
#' Specified either as "<design_document>" or ["<design_document>",
#' "<index_name>"]. Optional
#' @param as (character) One of list (default) or json
#' @examples \dontrun{
#' ## create a connection
#' (x <- Cushion$new(user = 'jane', pwd = 'foobar'))
#'
#' file <- system.file("examples/omdb.json", package = "sofa")
#' strs <- readLines(file)
#'
#' ## create a database
#' if ("leothelion" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="leothelion"))
#' }
#' db_create(x, dbname='leothelion')
#'
#' ## add some documents
#' invisible(bulk_create(x, "leothelion", strs))
#'
#' ## query all in one json blob
#' db_query(x, dbname = "leothelion", query = '{
#'   "selector": {
#'     "_id": {
#'       "$gt": null
#'     }
#'   }
#' }')
#'
#' ## query with each parameter
#' db_query(x, dbname = "leothelion",
#'   selector = list(`_id` = list(`$gt` = NULL)))
#'
#' db_query(x, dbname = "leothelion",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3)
#'
#' db_query(x, dbname = "leothelion",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3,
#'   fields = c('_id', 'Actors', 'imdbRating'))
#'
#' db_query(x, dbname = "leothelion",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3,
#'   fields = c('_id', 'Actors', 'imdbRating'),
#'   sort = list(imdbRating = "desc"))
#'
#' db_query(x, dbname = "leothelion",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3,
#'   fields = c('_id', 'Actors', 'imdbRating'),
#'   sort = "imdbRating")
#' }
db_query <- function(cushion, dbname, query = NULL, selector = NULL,
  limit = NULL, skip = NULL, sort = NULL, fields = NULL, use_index = NULL,
  as = 'list', ...) {

  check_cushion(cushion)
  if (is.null(query)) {
    query <- sc(list(
      selector = selector, limit = unbox(limit), skip = skip,
      sort = sort, fields = fields, use_index = use_index
    ))
    if (!is.null(query$sort)) {
      for (i in seq_along(query$sort)) {
        if (!is.null(names(query$sort)[i])) {
          query$sort[[i]] <- unbox(query$sort[[i]])
        } else {
          query$sort[[i]] <- unbox(query$sort[[i]])
        }
      }
      query$sort <- list(query$sort)
    }
    query <- jsonlite::toJSON(query)
  }
  sofa_POST(file.path(cushion$make_url(), dbname, "_find"), as,
            cushion$get_headers(), body = query, encode = "json", ...)
}
