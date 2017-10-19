#' Create documents via the bulk API
#'
#' @export
#' @template all
#' @param dbname (character) Database name. Required.
#' @param doc A data.frame, list, or JSON as a character string. Required.
#' @param docid Document IDs, ignored for now, eventually, you can pass in a
#' list, or vector to be the ids for each document created. Has to be the same
#' length as the number of documents.
#' @param how (character) One of rows (default) or columns. If rows, each row
#' becomes a separate document; if columns, each column becomes a separate
#' document.
#'
#' @details Note that row.names are dropped from data.frame inputs.
#'
#' @return Either a list or json (depending on \code{as} parameter), with
#' each element an array of key:value pairs:
#' \itemize{
#'  \item ok - whether creation was successful
#'  \item id - the document id
#'  \item rev - the revision id
#' }
#'
#' @examples \dontrun{
#' # initialize a CouchDB connection
#' (x <- Cushion$new())
#'
#' # From a data.frame
#' if ("bulktest" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulktest"))
#' }
#' db_create(x, dbname="bulktest")
#' db_bulk_create(x, "bulktest", mtcars)
#'
#' if ("bulktest2" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulktest2"))
#' }
#' db_create(x, dbname="bulktest2")
#' db_bulk_create(x, "bulktest2", iris)
#'
#' # data.frame with 1 or more columns as neseted lists
#' mtcars$stuff <- list("hello_world")
#' mtcars$stuff2 <- list("hello_world","things")
#' if ("bulktest3" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulktest3"))
#' }
#' db_create(x, dbname="bulktest3")
#' db_bulk_create(x, "bulktest3", mtcars)
#'
#' # From a json character string, or more likely, many json character strings
#' library("jsonlite")
#' strs <- as.character(parse_df(mtcars, "columns"))
#' if ("bulkfromchr" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulkfromchr"))
#' }
#' db_create(x, dbname="bulkfromchr")
#' db_bulk_create(x, "bulkfromchr", strs)
#'
#' # From a list of lists
#' library("jsonlite")
#' lst <- parse_df(mtcars, tojson=FALSE)
#' if ("bulkfromchr" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulkfromchr"))
#' }
#' db_create(x, dbname="bulkfromchr")
#' db_bulk_create(x, "bulkfromchr", lst)
#'
#' # iris dataset - by rows
#' if ("irisrows" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="irisrows"))
#' }
#' db_create(x, dbname="irisrows")
#' db_bulk_create(x, "irisrows", apply(iris, 1, as.list))
#'
#' # iris dataset - by columns - doesn't quite work yet
#' # if ("iriscolumns" %in% db_list(x)) {
#' #   invisible(db_delete(x, dbname="iriscolumns"))
#' # }
#' # db_create(x, dbname="iriscolumns")
#' # db_bulk_create(x, "iriscolumns", parse_df(iris, "columns", tojson=FALSE), how="columns")
#' }
db_bulk_create <- function(cushion, dbname, doc, docid = NULL,
                         how = 'rows', as = 'list', ...) {
  check_cushion(cushion)
  db_bulk_create_(doc, cushion, dbname, docid, how, as, ...)
}

db_bulk_create_ <- function(doc, cushion, dbname, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  UseMethod("db_bulk_create_")
}

#' @export
db_bulk_create_.character <- function(doc, cushion, dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  body <- sprintf('{"docs": [%s]}', paste0(doc, collapse = ", "))
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, cushion$get_headers(), ...)
}

#' @export
db_bulk_create_.list <- function(doc, cushion, dbname, docid = NULL,
                                  how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  body <- jsonlite::toJSON(list(docs = doc), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, cushion$get_headers(), ...)
}

#' @export
db_bulk_create_.data.frame <- function(doc, cushion, dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  row.names(doc) <- NULL
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  each <- unname(parse_df(doc, how = how, tojson = FALSE))
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body, cushion$get_headers(), ...)
}

sofa_bulk <- function(url, as, body, headers, ...) {
  cli <- crul::HttpClient$new(url = url, headers = c(ct_json, headers),
                              opts = list(...))
  res <- cli$post(body = body)
  #res <- POST(url, content_type_json(), body = body, ...)
  bulk_handle(res, as)
}

bulk_handle <- function(x, as) {
  stop_status(x)
  tt <- x$parse("UTF-8")
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}
