#' Include an attachment either on an existing or new document.
#'
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @param attachment The attachment object name
#' @param attname Attachment name.
#' @examples
#' # put on to an existing document
#' doc <- '{"name":"guy","beer":"anybeerisfine"}'
#' sofa_writedoc(dbname="sofadb", doc=doc, docid="guysbeer")
#' myattachment <- "just a simple text string"
#' myattachment <- mtcars
#' sofa_attach(dbname="sofadb", docid="guysbeer", attachment=myattachment, attname="mtcarstable.csv")
#' @export
sofa_attach <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid, attachment, attname)
{
  message("needs work still")
  #   revget <- sofa_getdoc(dbname=dbname, docid=docid)[["_rev"]] 
  #   call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, "/", attname, "?rev=", revget, sep="")
  #   out <- PUT(call_, body=attachment, config=list(httpheader='Content-Type: text/csv'))
  #   stop_for_status(out)
  #   fromJSON(content(out))
}
