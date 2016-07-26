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
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' changes(x, dbname="sofadb")
#' changes(x, dbname="sofadb", as='json')
#' changes(x, dbname="sofadb", limit=2)
#' }
changes <- function(cushion, dbname, descending=NULL, startkey=NULL, endkey=NULL,
  since=NULL, limit=NULL, include_docs=NULL, feed="normal", heartbeat=NULL,
  filter=NULL, as='list', ...) {

  check_cushion(cushion)
  args <- sc(list(descending=descending,startkey=startkey,endkey=endkey,
                  since=since,limit=limit,include_docs=include_docs,feed=feed,
                  heartbeat=heartbeat,filter=filter))

  call_ <- sprintf("%s/%s/_changes", cushion$make_url(), dbname)
  sofa_GET(call_, as, query = args, cushion$get_headers(), ...)
}
