#' Get an attachment.
#'
#' @export
#' @inheritParams ping
#' @param dbname (charcter) Database name. Required.
#' @param docid (charcter) Document ID. Required.
#' @param attname (charcter) Attachment name. Optional.
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
  sofa_GET(url, as, content_type_json(), query = list(`_attachments` = "true"),
           cushion$get_headers(), ...)
}
