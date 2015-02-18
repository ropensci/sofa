#' List changes to a database.
#'
#' @export
#' @inheritParams ping
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
#' @description Of course it doesn't make much sense to use certain options in
#'    _changes. For example, using feed=longpoll or continuous doesn't make much sense
#'    within R itself.
#' @examples \donttest{
#' changes(dbname="sofadb")
#' changes(dbname="sofadb", as='json')
#' changes(dbname="sofadb", limit=2)
#'
#' # different login credentials than normal, just pass in to function call
#' changes("cloudant", dbname='gaugesdb_ro')
#' changes("cloudant", dbname='gaugesdb_ro', as='json')
#' changes("cloudant", dbname='gaugesdb_ro', include_docs='true')
#'
#' # irishcouch
#' changes(cushion="iriscouch", dbname='helloworld')
#' changes(cushion="iriscouch", dbname='helloworld', include_docs='true')
#'
#' # arbitrary couch on remote server
#' changes("oceancouch", dbname="mapuris", as='json')
#' changes("oceancouch", dbname="mapuris", include_docs='true', limit=10)
#' }

changes <- function(cushion='localhost', dbname, descending=NULL, startkey=NULL, endkey=NULL,
  since=NULL, limit=NULL, include_docs=NULL, feed="normal", heartbeat=NULL,
  filter=NULL, as='list', ...)
{
  cushion <- get_cushion(cushion)
  args <- sc(list(descending=descending,startkey=startkey,endkey=endkey,
                  since=since,limit=limit,include_docs=include_docs,feed=feed,
                  heartbeat=heartbeat,filter=filter))
  if(is.null(cushion$type)){
    url <- pick_url(cushion)
    call_ <- sprintf("%s%s/_changes", url, dbname)
    sofa_GET(call_, as, query=args, ...)
  } else {
    if(cushion$type == "localhost"){
      call_ <- sprintf("http://127.0.0.1:%s/%s/_changes", cushion$port, dbname)
      sofa_GET(call_, as, query=args, ...)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      sofa_GET(remote_url(cushion, dbname, "_changes"), as, query=args, content_type_json(), ...)
    }
  }
}
