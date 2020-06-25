#' Query a database.
#'
#' @export
#' @template all
#' @template return
#' @param dbname Database name
#' @param query (character) instead of using the other parameters, you can
#' compose one R list or json blob here
#' @param selector (list/json) - JSON object describing criteria used to select
#' documents. More information provided in the section on selector syntax.
#' See the `query_tutorial` in this package, and the selectors docs
#' <http://docs.couchdb.org/en/2.0.0/api/database/find.html#find-selectors>
#' @param limit (numeric) - Maximum number of results returned. Default is 25.
#' Optional
#' @param skip (numeric) - Skip the first 'n' results, where 'n' is the value
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
#' @param r (numeric) Read quorum needed for the result. This defaults to 1,
#' in which case the document found in the index is returned. If set to a
#' higher value, each document is read from at least that many replicas before
#' it is returned in the results. This is likely to take more time than using
#' only the document stored locally with the index. Optional, default: 1
#' @param bookmark (character) A string that enables you to specify which
#' page of results you require. Used for paging through result sets. Every
#' query returns an opaque string under the bookmark key that can then be
#' passed back in a query to get the next page of results. If any part of
#' the selector query changes between requests, the results are undefined.
#' Optional, default: `NULL`
#' @param update (logical) Whether to update the index prior to returning the
#' result. Default is true. Optional
#' @param stable (logical) Whether or not the view results should be returned
#' from a “stable” set of shards. Optional
#' @param stale (character) Combination of `update=FALSE` and `stable=TRUE`
#' options. Possible options: "ok", "FALSE" (default). Optional
#' @param execution_stats (logical) Include execution statistics in the query
#' response. Optional, default: `FALSE`
#' @template query-egs
db_query <- function(cushion, dbname, query = NULL, selector = NULL,
  limit = NULL, skip = NULL, sort = NULL, fields = NULL, use_index = NULL,
  r = NULL, bookmark = NULL, update = NULL, stable = NULL, stale = NULL,
  execution_stats = FALSE, as = 'list', ...) {

  check_cushion(cushion)
  assert(selector, c("character", "list"))
  assert(limit, c("numeric", "integer"))
  assert(skip, c("numeric", "integer"))
  assert(sort, "character")
  assert(fields, "character")
  assert(use_index, "character")
  assert(r, c("numeric", "integer"))
  assert(bookmark, "character")
  assert(update, "logical")
  assert(stable, "logical")
  assert(stale, "character")
  assert(execution_stats, "logical")
  if (!is.null(fields)) if (length(fields) == 1) fields <- list(fields)
  if (is.null(query)) {
    query <- sc(list(
      selector = selector, limit = unbox(limit), skip = skip,
      sort = sort, fields = fields, use_index = use_index,
      r = r, bookmark = bookmark, update = update, stable = stable,
      execution_stats = execution_stats
    ))
    # if (!is.null(query$sort)) {
    #   for (i in seq_along(query$sort)) {
    #     if (!is.null(names(query$sort)[i])) {
    #       query$sort[[i]] <- unbox(query$sort[[i]])
    #     } else {
    #       query$sort[[i]] <- unbox(query$sort[[i]])
    #     }
    #   }
    #   query$sort <- list(query$sort)
    # }
    # query <- jsonlite::toJSON(query)
  }
  sofa_POST(file.path(cushion$make_url(), dbname, "_find"), as,
            body = query, encode = "json",
            cushion$get_headers(), cushion$get_auth(), ...)
}
