#' Query many documents at once
#'
#' @export
#' @template all
#' @param dbname (character) Database name. Required.
#' @param docid_rev A list of named lists, each of which must have the
#' slot `id`, and optionally `rev` for the revision of the document id
#' @return Either a list or json (depending on `as` parameter)
#' @examples \dontrun{
#' # initialize a CouchDB connection
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user = user, pwd = pwd))
#'
#' if ("bulkgettest" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname = "bulkgettest"))
#' }
#' db_create(x, dbname = "bulkgettest")
#' db_bulk_create(x, "bulkgettest", mtcars)
#' res <- db_query(x, dbname = "bulkgettest", selector = list(cyl = 8))
#'
#' # with ids only
#' ids <- vapply(res$docs, "[[", "", "_id")
#' ids_only <- lapply(ids[1:5], function(w) list(id = w))
#' db_bulk_get(x, "bulkgettest", docid_rev = ids_only)
#'
#' # with ids and revs
#' ids_rev <- lapply(
#'   res$docs[1:3],
#'   function(w) list(id = w$`_id`, rev = w$`_rev`)
#' )
#' db_bulk_get(x, "bulkgettest", docid_rev = ids_rev)
#' }
db_bulk_get <- function(cushion, dbname, docid_rev, as = "list", ...) {
  check_cushion(cushion)
  url <- sprintf("%s/%s/_bulk_get", cushion$make_url(), dbname)
  body <- list(docs = docid_rev)
  sofa_bulk(url, as,
    body = body,
    cushion$get_headers(), cushion$get_auth(), encode = "json", ...
  )
}
