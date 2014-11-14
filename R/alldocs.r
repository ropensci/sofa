#' List all docs in a given database.
#'
#' @export
#' @import plyr
#' @importFrom jsonlite fromJSON toJSON unbox
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name. (charcter)
#' @param asdf Return as data.frame? defaults to TRUE (logical)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' alldocs(dbname="sofadb")
#' alldocs(dbname="mydb", limit=2)
#' alldocs(dbname="mydb", limit=2, include_docs="true")
#' library('httr')
#' alldocs(dbname="sofadb", config=verbose())
#'
#' # different login credentials than normal, just pass in to function call
#' ## you obviously need to fill in some details here, this won't work as is
#' alldocs("cloudant", dbname='dbname')
#'
#' # this works for the package author, but not for you
#' alldocs(cushion="cloudant", dbname='gaugesdb_ro')
#'
#' # irishcouch
#' alldocs(cushion="iriscouch", dbname='helloworld')
#' }

alldocs <- function(cushion="localhost", dbname, asdf = TRUE,
  descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, include_docs=NULL, ...)
{
  cushion <- get_cushion(cushion)
  args <- sc(list(descending=descending, startkey=startkey,endkey=endkey,
                       limit=limit,include_docs=include_docs))

  if(cushion$type=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/_all_docs", cushion$port, dbname)
    temp <- sofa_GET(call_, args, ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    temp <- sofa_GET(remote_url(cushion, dbname, "_all_docs"), args, content_type_json(), ...)
  } else stop(paste0(cushion$type, " is not supported yet"))

  if(asdf & is.null(include_docs)) ldply(temp$rows, function(x) as.data.frame(x)) else temp
}
