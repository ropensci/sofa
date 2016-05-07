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
#' @param how (character) One of rows (default) or columns. If rows, each row becomes a
#' separate document; if columns, each column becomes a separate document.
#'
#' @details Note that row.names are dropped from data.frame inputs.
#'
#' @examples \dontrun{
#' # From a data.frame
#' db_delete(dbname="bulktest")
#' db_create(dbname="bulktest")
#' bulk_create(mtcars, dbname="bulktest")
#'
#' db_delete(dbname="bulktest2")
#' db_create(dbname="bulktest2")
#' bulk_create(iris, dbname="bulktest2")
#'
#' # data.frame with 1 or more columns as neseted lists
#' mtcars$stuff <- list("hello_world")
#' mtcars$stuff2 <- list("hello_world","things")
#' db_delete(dbname="bulktest3")
#' db_create(dbname="bulktest3")
#' bulk_create(mtcars, dbname="bulktest3")
#'
#' # From a json character string, or more likely, many json character strings
#' library("jsonlite")
#' strs <- as.character(parse_df(mtcars, "columns"))
#' db_delete(dbname="bulkfromchr")
#' db_create(dbname="bulkfromchr")
#' bulk_create(strs, dbname="bulkfromchr")
#'
#' # From a list of lists
#' library("jsonlite")
#' lst <- parse_df(mtcars, tojson=FALSE)
#' db_delete(dbname="bulkfromchr")
#' db_create(dbname="bulkfromchr")
#' bulk_create(lst, dbname="bulkfromchr")
#'
#' # iris dataset - by rows
#' db_delete(dbname="irisrows")
#' db_create(dbname="irisrows")
#' bulk_create(apply(iris, 1, as.list), dbname="irisrows")
#'
#' # iris dataset - by columns - doesn't quite work yet
#' # db_delete(dbname="iriscolumns")
#' # db_create(dbname="iriscolumns")
#' # bulk_create(parse_df(iris, "columns", tojson=FALSE), dbname="iriscolumns")
#' }
bulk_create <- function(doc, cushion = "localhost", dbname, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  UseMethod("bulk_create")
}

#' @export
bulk_create.character <- function(doc, cushion = "localhost", dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  url <- cush(cushion, dbname)
  body <- sprintf('{"docs": [%s]}', paste0(doc, collapse = ", "))
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, ...)
}

#' @export
bulk_create.list <- function(doc, cushion = "localhost", dbname, docid = NULL,
                                  how = 'rows', as = 'list', ...) {
  url <- cush(cushion, dbname)
  body <- jsonlite::toJSON(list(docs = doc), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, ...)
}

#' @export
bulk_create.data.frame <- function(doc, cushion = "localhost", dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  row.names(doc) <- NULL
  url <- cush(cushion, dbname)
  each <- unname(parse_df(doc, how = how, tojson = FALSE))
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, ...)
}

sofa_bulk <- function(url, as, body, ...) {
  res <- POST(url, content_type_json(), body = body)
  bulk_handle(res, as)
}

bulk_handle <- function(x, as) {
  stop_status(x)
  tt <- content(x, "text", encoding = "UTF-8")
  if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}
