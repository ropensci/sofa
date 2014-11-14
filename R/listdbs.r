#' List all databases.
#'
#' @export
#' @param cushion A cushion name
#' @param as (character) One of list (default) or json
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # local databasees
#' listdbs()
#' listdbs(as='json')
#' listdbs("cloudant")
#' listdbs("iriscouch")
#' }

listdbs <- function(cushion="localhost", as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    sofa_GET(sprintf("http://127.0.0.1:%s/%s", cushion$port, "_all_dbs"), NULL, as, ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    sofa_GET(remote_url(cushion, endpt = "_all_dbs"), NULL, as, content_type_json(), ...)
  }
}
