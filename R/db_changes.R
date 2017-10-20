#' List changes to a database.
#'
#' @export
#' @template all
#' @param dbname Database name. (character)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param since Start the results from the change immediately after the given
#' sequence number.
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs (character) If "true", returns docs themselves, in
#' addition to IDs
#' @param feed Select the type of feed. One of normal, longpoll, or continuous.
#' See description. (character)
#' @param heartbeat Period in milliseconds after which an empty line is sent in
#' the results. Only applicable for longpoll or continuous feeds. Overrides any
#' timeout to keep the feed alive indefinitely. (numeric (milliseconds))
#' @param filter Reference a filter function from a design document to
#' selectively get updates.
#' @description Of course it doesn't make much sense to use certain options in
#' _changes. For example, using feed=longpoll or continuous doesn't make much
#' sense within R itself.
#' @return Either a list of json (depending on `as` parameter), with
#' keys:
#'
#' - results - Changes made to a database, length 0 if no changes.
#'  Each of these has:
#'   - changes - List of document`s leafs with single field rev
#'   - id - Document ID
#'   - seq - Update sequence
#' - last_seq - Last change update sequence
#' - pending - Count of remaining items in the feed
#'
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("leothelion" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="leothelion"))
#' }
#' db_create(x, dbname='leothelion')
#'
#' # no changes
#' res <- db_changes(x, dbname="leothelion")
#' res$results
#'
#' # create a document
#' doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
#' doc_create(x, dbname="leothelion", doc1, docid="abeer")
#'
#' # now there's changes
#' res <- db_changes(x, dbname="leothelion")
#' res$results
#'
#' # as JSON
#' db_changes(x, dbname="leothelion", as='json')
#' }
db_changes <- function(cushion, dbname, descending=NULL, startkey=NULL,
  endkey=NULL, since=NULL, limit=NULL, include_docs=NULL, feed="normal",
  heartbeat=NULL, filter=NULL, as='list', ...) {

  check_cushion(cushion)
  args <- sc(list(descending=descending,startkey=startkey,endkey=endkey,
                  since=since,limit=limit,include_docs=include_docs,feed=feed,
                  heartbeat=heartbeat,filter=filter))

  call_ <- sprintf("%s/%s/_changes", cushion$make_url(), dbname)
  sofa_GET(call_, as, query = args,
           cushion$get_headers(),
           cushion$get_auth(), ...)
}
