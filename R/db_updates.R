#' Get information on database updates
#'
#' @export
#' @inheritParams ping
#' @param feed (character) One of longpoll (default), continuous, or eventsource. See Details.
#' @param timeout (integer) Number of seconds until CouchDB closes the connection. Default: 60.
#' @param heartbeat (logical) Whether CouchDB will send a newline character on timeout.
#' Default: true
#'
#' @details This may not be very appropriate for use in R, but who knows, so here it is.
#'
#' Also, continuous and eventsource don't seem to work in R, unless I'm missing something.
#'
#' Options for the \code{feed} parmeter:
#' \itemize{
#'  \item longpoll: Closes the connection after the first event.
#'  \item continuous: Send a line of JSON per event. Keeps the socket open until timeout.
#'  \item eventsource: Like, continuous, but sends the events in EventSource format.
#' }
#'
#' @examples \dontrun{
#' (x <- Cushion$new())
#' db_updates(x)
#' db_updates(feed="continuous")
#' db_updates(feed="eventsource")
#' }
db_updates <- function(cushion, feed = 'longpoll', timeout = 60, heartbeat = TRUE,
                       as = 'list', ...) {
  check_cushion(cushion)
  args <- sc(list(feed = feed, timeout = timeout, heartbeat = tolower(heartbeat)))
  sofa_GET(paste0(cushion$make_url(), "_db_updates"), as=as, args=args, cushion$get_headers(), ...)
}
