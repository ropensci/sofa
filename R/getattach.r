#' Get an attachment.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @param attname Attachment name.
#' @examples \donttest{
#' getattach(dbname="sofadb", docid="abeer")
#' }

getattach <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid, attname=NULL, ...)
{
  if(is.null(attname)){
    call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, "?_attachments=true", sep="")
  } else
  {
    call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, "/", attname, sep="")
  }
  sofa_GET(call_, ...)
}
