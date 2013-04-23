#' List all docs in a given database.
#'
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @param asdf Return as data.frame? defaults to TRUE (logical)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @examples
#' sofa_alldocs(dbname="sofadb")
#' sofa_alldocs(dbname="twitter_db", limit=2)
#' sofa_alldocs(dbname="twitter_db", limit=2, include_docs="true")
#' @export
sofa_alldocs <- function(endpoint="http://127.0.0.1", port=5984, dbname, asdf = TRUE,
                         descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, 
                         include_docs=NULL)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/_all_docs", sep="")
  args <- compact(list(descending=descending, startkey=startkey,endkey=endkey,
                       limit=limit,include_docs=include_docs))
  temp <- fromJSON(content(GET(call_, query=args)))
  if(asdf & is.null(include_docs)){
    return( ldply(temp$rows, function(x) as.data.frame(x)) )
  } else
  { temp }
}