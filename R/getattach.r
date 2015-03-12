#' Get an attachment.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @param attname Attachment name.
#' @examples \donttest{
#' attach_get(dbname="sofadb", docid="guysbeer")
#' attach_get("oceancouch", dbname="mapuris", docid="goodbeer")
#' }

attach_get <- function(cushion="localhost", dbname, docid, attname=NULL, as='list', ...) {

  cushion <- get_cushion(cushion)
  url <- pick_url(cushion)
  if(is.null(attname)){
    call_ <- paste(url, "/", dbname, "/", docid, "?_attachments=true", sep="")
  } else
  {
    call_ <- paste(url, "/", dbname, "/", docid, "/", attname, sep="")
  }
  sofa_GET(call_, as, content_type_json(), ...)
}
