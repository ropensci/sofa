#' List all databases.
#'
#' @export
#' @param cushion A cushion name
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # local databasees
#' listdbs()
#' listdbs("cloudant")
#' listdbs("iriscouch")
#' }

listdbs <- function(cushion="localhost", ...)
{
  cushion <- get_cushion(cushion)
  if(cushion$type=="localhost"){
    sofa_GET(sprintf("http://127.0.0.1:%s/%s", cushion$port, "_all_dbs"), ...)
  } else if(cushion$type %in% c("cloudant",'iriscouch')){
    sofa_GET(remote_url(cushion, endpt = "_all_dbs"), NULL, content_type_json(), ...)
  } else stop(paste0(cushion$type, " is not supported yet"))
}
