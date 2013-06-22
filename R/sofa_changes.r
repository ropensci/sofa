#' List changes to a database.
#'
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param since Start the results from the change immediately after the given sequence number.
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If "true", returns docs themselves, in addition to IDs (character)
#' @param feed Select the type of feed. One of normal, longpoll, or continuous. (character)
#' @param heartbeat Period in milliseconds after which an empty line is sent in the results. 
#'    Only applicable for longpoll or continuous feeds. Overrides any timeout to keep the 
#'    feed alive indefinitely. (numeric (milliseconds))
#' @param filter Reference a filter function from a design document to selectively get updates. 
#' @param username User name
#' @param pwd Password
#' @examples
#' sofa_changes(dbname="sofadb")
#' sofa_changes(dbname="sofadb", limit=2)
#' @export
sofa_changes <- function(endpoint="localhost", port=5984, dbname, 
  descending=NULL, startkey=NULL, endkey=NULL, since=NULL, limit=NULL, include_docs=NULL,
  feed="normal", heartbeat=NULL, filter=NULL, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  args <- compact(list(descending=descending,startkey=startkey,endkey=endkey,
                       since=since,limit=limit,include_docs=include_docs,feed=feed,
                       heartbeat=heartbeat,filter=filter))
  
  if(endpoint=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/_changes", port, dbname)
    out <- GET(call_, query=args)
    stop_for_status(out)
    fromJSON(content(out))
  } else
    if(endpoint=="cloudant"){
      auth <- get_pwd(username,pwd,"cloudant")
      call_ <- sprintf('https://%s:%s@%s.cloudant.com/%s/_changes', auth[[1]], auth[[2]], auth[[1]], dbname)
      out <- GET(call_, query=args, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
      fromJSON(content(out))
    } else
    {
      auth <- get_pwd(username,pwd,"iriscouch")
      call_ <- sprintf('https://%s.iriscouch.com/%s/_changes', auth[[1]], dbname)
      out <- GET(url, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
      fromJSON(content(out))
    }
}