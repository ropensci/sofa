#' Create documents via the bulk API
#'
#' @export
#' @inheritParams ping
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname (character) Database name. Required.
#' @param doc For now, a data.frame only. Required.
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
#' (x <- Cushion$new())
#'
#' # From a data.frame
#' db_delete(x, dbname="bulktest")
#' db_create(x, dbname="bulktest")
#' bulk_create(x, mtcars, dbname="bulktest")
#'
#' db_delete(x, dbname="bulktest2")
#' db_create(x, dbname="bulktest2")
#' bulk_create(x, iris, dbname="bulktest2")
#'
#' # data.frame with 1 or more columns as neseted lists
#' mtcars$stuff <- list("hello_world")
#' mtcars$stuff2 <- list("hello_world","things")
#' db_delete(x, dbname="bulktest3")
#' db_create(x, dbname="bulktest3")
#' bulk_create(x, mtcars, dbname="bulktest3")
#'
#' # From a json character string, or more likely, many json character strings
#' library("jsonlite")
#' strs <- as.character(parse_df(mtcars, "columns"))
#' db_delete(x, dbname="bulkfromchr")
#' db_create(x, dbname="bulkfromchr")
#' bulk_create(x, strs, dbname="bulkfromchr")
#'
#' # From a list of lists
#' library("jsonlite")
#' lst <- parse_df(mtcars, tojson=FALSE)
#' db_delete(x, dbname="bulkfromchr")
#' db_create(x, dbname="bulkfromchr")
#' bulk_create(x, lst, dbname="bulkfromchr")
#'
#' # iris dataset - by rows
#' db_delete(x, dbname="irisrows")
#' db_create(x, dbname="irisrows")
#' bulk_create(x, apply(iris, 1, as.list), dbname="irisrows")
#'
#' # iris dataset - by columns - doesn't quite work yet
#' # db_delete(x, dbname="iriscolumns")
#' # db_create(x, dbname="iriscolumns")
#' # bulk_create(x, parse_df(iris, "columns", tojson=FALSE), dbname="iriscolumns")
#' }
bulk_create <- function(cushion, dbname, doc, docid = NULL,
                         how = 'rows', as = 'list', ...) {
  check_cushion(cushion)
  bulk_create_(doc, cushion, dbname, docid, how, as, ...)
}

bulk_create_ <- function(doc, cushion, dbname, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  UseMethod("bulk_create_")
}

#' @export
bulk_create_.character <- function(doc, cushion, dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  body <- sprintf('{"docs": [%s]}', paste0(doc, collapse = ", "))
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, cushion$get_headers(), ...)
}

#' @export
bulk_create_.list <- function(doc, cushion, dbname, docid = NULL,
                                  how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  body <- jsonlite::toJSON(list(docs = doc), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, cushion$get_headers(), ...)
}

#' @export
bulk_create_.data.frame <- function(doc, cushion, dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  row.names(doc) <- NULL
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  each <- unname(parse_df(doc, how = how, tojson = FALSE))
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, cushion$get_headers(), ...)
}

sofa_bulk <- function(url, as, body, ...) {
  res <- POST(url, content_type_json(), body = body)
  bulk_handle(res, as)
}

bulk_handle <- function(x, as) {
  stop_status(x)
  tt <- content(x, "text", encoding = "UTF-8")
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}
