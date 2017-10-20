#' Query a database.
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
#' @param limit (number) - Maximum number of results returned. Default is 25.
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
#' @template query-egs
db_query <- function(cushion, dbname, query = NULL, selector = NULL,
  limit = NULL, skip = NULL, sort = NULL, fields = NULL, use_index = NULL,
  as = 'list', ...) {

  check_cushion(cushion)
  if (is.null(query)) {
    query <- sc(list(
      selector = selector, limit = unbox(limit), skip = skip,
      sort = sort, fields = fields, use_index = use_index
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
            cushion$get_headers(), body = query, encode = "json", ...)
}
