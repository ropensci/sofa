#' Create and get database indexes
#'
#' @export
#' @template all
#' @template return
#' @param dbname (character) Database name, required
#' @param body (named list) index fields, required
#' @param design (character) Design document name
#' @param index_name (character) index name
#'
#' @section Body parameters:
#'
#' - index (json) - JSON object describing the index to create.
#' - ddoc (string) - Name of the design document in which the index will be
#' created. By default, each index will be created in its own design
#' document. Indexes can be grouped into design documents for efficiency.
#' However, a change to one index in a design document will invalidate all
#' other indexes in the same document (similar to views). Optional
#' - name (string) - Name of the index. If no name is provided, a name will
#' be generated automatically. Optional
#' - type (string) - Can be "json" or "text". Defaults to json. Geospatial
#' indexes will be supported in the future. Optional Text indexes are
#' supported via a third party library Optional
#' - partial_filter_selector (json) - A selector to apply to documents at
#' indexing time, creating a partial index. Optional
#'
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' # create a database first
#' if ("testing" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="testing"))
#' }
#' db_create(x, "testing")
#'
#' # get indexes
#' db_index(x, "testing")
#'
#' # create indexes
#' body <- list(index = list(fields = I("foo")), name = "foo-index", type = "json")
#' db_index_create(x, "testing", body = body)
#'
#' # get indexes, after creating another index
#' db_index(x, "testing")
#'
#' # delete an index
#' res <- db_index(x, "testing")
#' db_index_delete(x, "testing", res$indexes[[2]]$ddoc, res$indexes[[2]]$name)
#' ## and it's gone
#' db_index(x, "testing")
#' }
db_index <- function(cushion, dbname, as = 'list', ...) {
  check_cushion(cushion)
  sofa_GET(file.path(cushion$make_url(), dbname, "_index"), as,
          headers = cushion$get_headers(),
          auth = cushion$get_auth(), ...)
}

#' @export
#' @rdname db_index
db_index_create <- function(cushion, dbname, body, as = 'list', ...) {
  check_cushion(cushion)
  sofa_POST(file.path(cushion$make_url(), dbname, "_index"), as,
          body = body, encode = "json",
          headers = cushion$get_headers(),
          auth = cushion$get_auth(), ...)
}

#' @export
#' @rdname db_index
db_index_delete <- function(cushion, dbname, design, index_name, as = 'list', ...) {
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), dbname, "_index", design, "json", index_name)
  sofa_DELETE(url, as, headers = cushion$get_headers(),
  	auth = cushion$get_auth(), ...)
}
