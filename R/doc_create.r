#' Create documents to a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name3
#' @param doc Document content, can be character string, a list. The character
#' type can be XML as well, which is embedded in json. When the document is
#' retrieved via \code{\link{doc_get}}, the XML is given back and you can parse
#' it as normal.
#' @param docid Document ID
#' @param how (character) One of rows (default) or columns. If rows, each row
#' becomes a separate document; if columns, each column becomes a separate
#' document.
#'
#' @details Documents can have attachments just like email. There are two ways
#' to use attachments: the first one is via a separate REST call
#' (see \code{\link{attach_create}}); the second is inline within your
#' document, you can do so with this fxn. See
#' \url{http://wiki.apache.org/couchdb/HTTP_Document_API#Attachments} for help
#' on formatting json appropriately.
#'
#' Note that you can create documents from a data.frame with this function,
#' where each row or column is a seprate document. However, this function does
#' not use the bulk API
#' \url{https://couchdb.readthedocs.org/en/latest/api/database/bulk-api.html#db-bulk-docs}
#' - see \code{\link{db_bulk_create}} and \code{\link{db_bulk_update}} to
#' create or update documents with the bulk API - which should be much faster
#' for a large number of documents.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("sofadb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="sofadb"))
#' }
#' db_create(x, dbname='sofadb')
#'
#' # write a document WITH a name (uses PUT)
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="sofadb", doc1, docid="abeer")
#' doc_create(x, dbname="sofadb", doc1, docid="morebeer", as='json')
#' doc_get(x, dbname = "sofadb", docid = "abeer")
#' ## with factor class values
#' doc2 <- list(name = as.factor("drink"), beer = "stout", score = 4)
#' doc_create(x, doc2, dbname="sofadb", docid="nextbeer", as='json')
#' doc_get(x, dbname = "sofadb", docid = "nextbeer")
#'
#' # write a json document WITHOUT a name (uses POST)
#' doc2 <- '{"name": "food", "icecream": "rocky road"}'
#' doc_create(x, doc2, dbname="sofadb")
#' doc3 <- '{"planet": "mars", "size": "smallish"}'
#' doc_create(x, doc3, dbname="sofadb")
#' ## assigns a UUID instead of a user given name
#' alldocs(x, dbname = "sofadb")
#'
#' # write an xml document WITH a name (uses PUT). xml is written as xml in
#' # couchdb, just wrapped in json, when you get it out it will be as xml
#' doc4 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' doc_create(x, doc4, dbname="sofadb", docid="somexml")
#' doc_get(x, dbname = "sofadb", docid = "somexml")
#'
#' # You can pass in lists that autoconvert to json internally
#' doc1 <- list(name = "drink", beer = "IPA", score = 9)
#' doc_create(doc1, dbname="sofadb", docid="goodbeer")
#'
#' # Write directly from a data.frame
#' ## Each row or column becomes a separate document
#' ### by rows
#' db_create(x, dbname = "test")
#' doc_create(x, mtcars, dbname="test", how="rows")
#' doc_create(x, mtcars, dbname="test", how="columns")
#'
#' head(iris)
#' db_create(x, dbname = "testiris")
#' doc_create(x, iris, dbname = "testiris")
#' }
doc_create <- function(cushion, dbname, doc, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  check_cushion(cushion)
  doc_create_(doc, cushion, dbname, docid, how, as, ...)
}

doc_create_ <- function(doc, cushion, dbname, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  UseMethod("doc_create_")
}

doc_create_.character <- function(doc, cushion, dbname, docid = NULL,
                                 how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  if (!is.null(docid)) {
    sofa_PUT(paste0(url, "/", docid), as, body = check_inputs(doc), cushion$get_headers(), ...)
  } else {
    sofa_POST(url, as, body = check_inputs(doc), ...)
  }
}

doc_create_.list <- function(doc, cushion, dbname, docid = NULL,
                                 how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  if (!is.null(docid)) {
    sofa_PUT(paste0(url, "/", docid), as, body = check_inputs(doc), cushion$get_headers(), ...)
  } else {
    sofa_POST(url, as, body = check_inputs(doc), ...)
  }
}

doc_create_.data.frame <- function(doc, cushion, dbname, docid = NULL,
                            how = 'rows', as = 'list', ...) {
  url <- sprintf("%s/%s", cushion$make_url(), dbname)
  each <- parse_df(doc, how = how)
  lapply(each, function(x) sofa_POST(url, as, body = x, cushion$get_headers(), ...))
}
