#' Get an attachment.
#'
#' @export
#' @template all
#' @template return
#' @param dbname (character) Database name. Required.
#' @param docid (character) Document ID. Required.
#' @param attname (character) Attachment name. Optional.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' attach_get(x, dbname="sofadb", docid="guysbeer")
#' }
attach_get <- function(cushion, dbname, docid, attname = NULL, as = 'list', ...) {
  check_cushion(cushion)
  if (is.null(attname)) {
    url <- file.path(cushion$make_url(), dbname, docid)
  } else {
    url <- file.path(cushion$make_url(), dbname, docid, attname)
  }
  sofa_GET(url, as, query = list(`_attachments` = "true"),
           cushion$get_headers(), ...)
}
