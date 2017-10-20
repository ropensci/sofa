#' Create documents via the bulk API
#'
#' @export
#' @template all
#' @param dbname (character) Database name. Required.
#' @param doc For now, a data.frame only. Required.
#' @param docid Document IDs, ignored for now, eventually, you can pass in a
#' list, or vector to be the ids for each document created. Has to be the same
#' length as the number of documents.
#' @param how (character) One of rows (default) or columns. If rows, each row
#' becomes a separate document; if columns, each column becomes a separate
#' document.
#'
#' @return Either a list or json (depending on `as` parameter), with
#' each element an array of key:value pairs:
#'
#' - ok - whether creation was successful
#' - id - the document id
#' - rev - the revision id
#'
#' @examples \dontrun{
#' # initialize a CouchDB connection
#' (x <- Cushion$new())
#'
#' row.names(mtcars) <- NULL
#'
#' if ("bulktest" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulktest"))
#' }
#' db_create(x, dbname="bulktest")
#' db_bulk_create(x, mtcars, dbname="bulktest")
#'
#' # modify mtcars
#' mtcars$letter <- sample(letters, NROW(mtcars), replace = TRUE)
#' db_bulk_update(x, "bulktest", mtcars)
#'
#' # change again
#' mtcars$num <- 89
#' db_bulk_update(x, "bulktest", mtcars)
#' }
db_bulk_update <- function(cushion, dbname, doc, docid = NULL,
                        how = 'rows', as = 'list', ...) {
  check_cushion(cushion)
  db_bulk_update_(doc, cushion, dbname, docid, how, as, ...)
}

db_bulk_update_ <- function(doc, cushion, dbname, docid = NULL,
                        how = 'rows', as = 'list', ...) {
  UseMethod("db_bulk_update_")
}

#' @export
db_bulk_update_.default <- function(doc, cushion, dbname, docid = NULL,
                                       how = 'rows', as = 'list', ...) {
  stop("No 'db_bulk_update' method for class ", class(doc), call. = FALSE)
}


#' @export
db_bulk_update_.data.frame <- function(doc, cushion, dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  row.names(doc) <- NULL
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  each <- unname(parse_df(doc, how = how, tojson = FALSE))
  info <- db_alldocs(cushion, dbname = dbname)
  each <- Map(function(x, y) utils::modifyList(x, list(`_id` = y$id, `_rev` = y$value$rev)), each, info$rows)
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body,
            cushion$get_headers(), cushion$get_auth(), ...)
}
