#' Create documents via the bulk API
#'
#' @export
#' @inheritParams ping
#' @param doc For now, a data.frame only
#' @param cushion A cushion name
#' @param dbname Database name3
#' \code{\link{doc_get}}, the XML is given back and you can parse it as normal.
#' @param docid Document IDs, ignored for now, eventually, you can pass in a list, or
#' vector to be the ids for each document created. Has to be the same length as the
#' number of documents.
#'
#' @examples \dontrun{
#' db_delete(dbname="bulktest")
#' db_create(dbname="bulktest")
#' doc_bulk(mtcars, dbname="bulktest")
#'
#' db_create(dbname="bulktest2")
#' doc_bulk(iris, dbname="bulktest2")
#' }
doc_bulk <- function(doc, cushion = "localhost", dbname, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  UseMethod("doc_bulk")
}

#' @export
doc_bulk.data.frame <- function(doc, cushion = "localhost", dbname, how = 'rows', as = 'list', ...) {
  url <- cush(cushion, dbname)
  each <- parse_df(doc, how = how, tojson = FALSE)
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, ...)
}

sofa_bulk <- function(url, as, body, ...) {
  res <- POST(url, content_type_json(), body = body, ...)
  stop_status(res)
  tt <- content(res, "text")
  if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}
