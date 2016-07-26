#' List all docs in a given database.
#'
#' @export
#' @import plyr
#' @importFrom jsonlite fromJSON toJSON unbox
#' @inheritParams ping
#' @param cushion A \code{Cushion} object. Required.
#' @param dbname Database name. (charcter)
#' @param asdf Return as data.frame? defaults to TRUE (logical)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' alldocs(x, dbname="sofadb")
#' alldocs(x, dbname="sofadb", as='json')
#' alldocs(x, dbname="mydb", limit=2)
#' alldocs(x, dbname="mydb", limit=2, include_docs="true")
#' library('httr')
#' alldocs(x, dbname="sofadb", config=verbose())
#' }

alldocs <- function(cushion, dbname, asdf = TRUE,
  descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, include_docs=NULL, as='list', ...) {

  check_cushion(cushion)
  args <- sc(list(descending=descending, startkey=startkey,endkey=endkey,
                       limit=limit,include_docs=include_docs))

  call_ <- sprintf("%s/%s/_all_docs", cushion$make_url(), dbname)
  temp <- sofa_GET(call_, as, query = args, cushion$get_headers(), ...)

  if (as == 'json') {
    temp
  } else {
    if (asdf & is.null(include_docs)) ldply(temp$rows, data.frame, stringsAsFactors = FALSE) else temp
  }
}
