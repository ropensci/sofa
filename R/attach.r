#' Include an attachment either on an existing or new document
#'
#' @export
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname (charcter) Database name. Required.
#' @param docid (charcter) Document ID. Required.
#' @param attachment (charcter) The attachment object name. Required.
#' @param attname (charcter) Attachment name. Required.
#' @param ... Curl args passed on to \code{\link[httr]{POST}}
#' @return a list
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("drinksdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="drinksdb"))
#' }
#' db_create(x, dbname='drinksdb')
#'
#' # put on to an existing document
#' doc <- '{"name":"stuff", "drink":"soda"}'
#' doc_create(x, dbname="drinksdb", doc=doc, docid="asoda")
#' myattachment <- "just a simple text string"
#' myattachment <- mtcars
#' attach_create(x, dbname="drinksdb", docid="asoda",
#'   attachment=myattachment, attname="mtcarstable.csv")
#' }
attach_create <- function(cushion, dbname, docid, attachment, attname, ...) {
  check_cushion(cushion)
  revget <- db_revisions(cushion, dbname = dbname, docid = docid)[1]
  url <- file.path(cushion$make_url(), dbname, docid, attname)
  out <- PUT(url, query = list(rev = revget),
             body = attachment, content_type("text/csv"), cushion$get_headers(), ...)
  stop_status(out)
  jsonlite::fromJSON(content(out, "text", encoding = "UTF-8"))
}
