#' Include an attachment either on an existing or new document
#'
#' @export
#' @inheritParams ping
#' @param dbname (charcter) Database name. Required.
#' @param docid (charcter) Document ID. Required.
#' @param attachment (charcter) The attachment object name. Required.
#' @param attname (charcter) Attachment name. Required.
#' @examples \dontrun{
#' (x <- Cushion$new(user = 'jane', pwd = 'foobar'))
#'
#' # put on to an existing document
#' doc <- '{"name":"guy","beer":"anybeerisfine"}'
#' doc_create(x, dbname="sofadb", doc=doc, docid="guysbeer")
#' myattachment <- "just a simple text string"
#' myattachment <- mtcars
#' attach_create(x, dbname="sofadb", docid="guysbeer",
#'   attachment=myattachment, attname="mtcarstable.csv")
#' }
attach_create <- function(cushion, dbname, docid, attachment, attname, ...) {
  check_cushion(cushion)
  revget <- revisions(cushion, dbname = dbname, docid = docid)[1]
  url <- file.path(cushion$make_url(), dbname, docid, attname)
  out <- PUT(url, query = list(rev = revget),
             body = attachment, content_type("text/csv"), cushion$get_headers(), ...)
  stop_status(out)
  jsonlite::fromJSON(content(out, "text", encoding = "UTF-8"))
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
