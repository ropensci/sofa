#' Create documents via the bulk API
#'
#' @export
#' @inheritParams ping
#' @param dbname (character) Database name. Required.
#' @param doc For now, a data.frame only. Required.
#' @param docid Document IDs, ignored for now, eventually, you can pass in a
#' list, or vector to be the ids for each document created. Has to be the same
#' length as the number of documents.
#' @param how (character) One of rows (default) or columns. If rows, each row
#' becomes a separate document; if columns, each column becomes a separate
#' document.
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
#' # initialize a couchdb connection
#' (x <- Cushion$new())
#'
#' row.names(mtcars) <- NULL
#'
#' if ("bulktest" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="bulktest"))
#' }
#' db_create(x, dbname="bulktest")
#' bulk_create(x, mtcars, dbname="bulktest")
#'
#' # modify mtcars
#' mtcars$letter <- sample(letters, NROW(mtcars), replace = TRUE)
#' bulk_update(x, "bulktest", mtcars)
#'
#' # change again
#' mtcars$num <- 89
#' bulk_update(x, "bulktest", mtcars)
#' }
bulk_update <- function(cushion, dbname, doc, docid = NULL,
                        how = 'rows', as = 'list', ...) {
  check_cushion(cushion)
  bulk_update_(doc, cushion, dbname, docid, how, as, ...)
}

bulk_update_ <- function(doc, cushion, dbname, docid = NULL,
                        how = 'rows', as = 'list', ...) {
  UseMethod("bulk_update_")
}

#' @export
bulk_update_.data.frame <- function(doc, cushion, dbname, docid = NULL,
                                   how = 'rows', as = 'list', ...) {
  row.names(doc) <- NULL
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  each <- unname(parse_df(doc, how = how, tojson = FALSE))
  info <- apply(alldocs(cushion, dbname = dbname), 1, as.list)
  each <- Map(function(x, y) modifyList(x, list(`_id` = y$id, `_rev` = y$rev)), each, info)
  body <- jsonlite::toJSON(list(docs = each), auto_unbox = TRUE)
  sofa_bulk(file.path(url, "_bulk_docs"), as, body = body)
}
