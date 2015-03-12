#' List all databases.
#'
#' @export
#' @param cushion A cushion name
#' @param simplify (logical) Simplify to character vector, ignored if \code{as="json"}
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # local databasees
#' db_list()
#' db_list(as='json')
#' db_list("cloudant")
#' db_list("iriscouch")
#' db_list("oceancouch")
#' }

db_list <- function(cushion="localhost", simplify=TRUE, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    url <- pick_url(cushion)
    tmp <- sofa_GET(sprintf("%s_all_dbs", url), as, ...)
  } else {
    if(cushion$type=="localhost"){
      tmp <- sofa_GET(sprintf("http://127.0.0.1:%s/%s", cushion$port, "_all_dbs"), as, ...)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      tmp <- sofa_GET(remote_url(cushion, endpt = "_all_dbs"), as, content_type_json(), ...)
    }
  }
  if(simplify && as=='list') do.call(c, tmp) else tmp
}
