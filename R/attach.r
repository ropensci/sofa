#' Include an attachment either on an existing or new document.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @param attachment The attachment object name
#' @param attname Attachment name.
#' @examples \dontrun{
#' # put on to an existing document
#' doc <- '{"name":"guy","beer":"anybeerisfine"}'
#' doc_create(dbname="sofadb", doc=doc, docid="guysbeer")
#' myattachment <- "just a simple text string"
#' myattachment <- mtcars
#' attach_create(dbname="sofadb", docid="guysbeer", attachment=myattachment, attname="mtcarstable.csv")
#' }

attach_create <- function(cushion="localhost", dbname, docid, attachment, attname, ...) {
  # message("needs work still")
  cushion <- get_cushion(cushion)
  revget <- revisions(dbname=dbname, docid=docid)[1]
  call_ <- sprintf("http://127.0.0.1:%s/%s/%s/%s", cushion$port, dbname, docid, attname)
  out <- PUT(call_, query=list(rev=revget), body=attachment, content_type("text/csv"))
  stop_for_status(out)
  fromJSON(content(out, "text"))
}

# PUT('http://localhost:5984/sofadb/guysbeer/mtcars.csv',
#     body=list(file=upload_file("mtcars.csv")),
#     query=list(rev = revget)
#     # encode="multipart",
#     # content_type("text/csv")
#     # content_type("text/plain")
# )

#     body=list(
#       `_rev` = revget,
#       `_attachments` = list(
#         `/Users/sacmac/mtcars.csv` = list(
#           "content_type" = "text/csv"
#         )
#     )),
#     content_type_json()
# )

# curl -XPUT 'http://localhost:5984/sofadb/guysbeer' -d '{
# 	"_attachments": {
# 		"/Users/sacmac/mtcars.csv": {
# 			"content_type": "text/csv"
# 		}
# 	}
# }' -H "Content-Type:application/json"
#
#
# curl -XPUT \
#   -H 'Content-Type: text/csv' \
#   --data-binary @mtcars.csv \
#   'http://localhost:5984/sofadb/guysbeer/mtcars.csv?rev=23-8f8951e0afa79a1c500697cdb83e442f'
