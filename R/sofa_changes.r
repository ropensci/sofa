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
#' @param feed Select the type of feed. One of normal, longpoll, or continuous. See description. (character)
#' @param heartbeat Period in milliseconds after which an empty line is sent in the results. 
#'    Only applicable for longpoll or continuous feeds. Overrides any timeout to keep the 
#'    feed alive indefinitely. (numeric (milliseconds))
#' @param filter Reference a filter function from a design document to selectively get updates. 
#' @param username User name
#' @param pwd Password
#' @description Of course it doesn't make much sense to use certain options in
#'    _changes. For example, using feed=longpoll or continuous doesn't make much sense
#'    within R itself.
#' @examples
#' sofa_changes(dbname="sofadb")
#' sofa_changes(dbname="sofadb", limit=2)
#' 
#' # different login credentials than normal, just pass in to function call
#' sofa_changes("cloudant", dbname='gaugesdb_ro', username='app16517180.heroku', pwd='DA1w5hbKJJAtcGnF74Ds3nVl', include_docs='true')
#' @export
sofa_changes <- function(endpoint="localhost", port=5984, dbname, 
  descending=NULL, startkey=NULL, endkey=NULL, since=NULL, limit=NULL, include_docs=NULL,
  feed="normal", heartbeat=NULL, filter=NULL, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  args <- sc(list(descending=descending,startkey=startkey,endkey=endkey,
                       since=since,limit=limit,include_docs=include_docs,feed=feed,
                       heartbeat=heartbeat,filter=filter))
  
  if(endpoint=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/_changes", port, dbname)
    out <- GET(call_, query=args)
    stop_for_status(out)
    fromJSON(content(out))
  } else
    if(endpoint=="cloudant"){
      if(is.null(username) | is.null(pwd)){ auth <- get_pwd(username,pwd,"cloudant") } else { auth <- c(username, pwd) }
      call_ <- sprintf('https://%s:%s@%s.cloudant.com/%s/_changes', auth[[1]], auth[[2]], auth[[1]], dbname)
      out <- GET(call_, query=args, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
      fromJSON(content(out))
    } else
    {
      if(is.null(username) | is.null(pwd)){ auth <- get_pwd(username,pwd,"iriscouch") } else { auth <- c(username, pwd) }
      call_ <- sprintf('https://%s.iriscouch.com/%s/_changes', auth[[1]], dbname)
      out <- GET(url, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
      fromJSON(content(out))
    }
}