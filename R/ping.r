#' Ping a couchdb server.
#'
#' @import httr
#' @export
#' @param cushion A cushion name
#' @param port port to connect to, defaults to 5984
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' ping()
#' ping("cloudant")
#' ping("iriscouch")
#' }

ping <- function(cushion="localhost", port=5984, username=NULL, pwd=NULL, ...)
{
  cushion <- get_cushion(cushion)
  url <- switch(cushion$type,
         localhost = paste0("http://127.0.0.1:", cushion$port),
         cloudant = cloudant_url(cushion, ''),
         iriscouch = iris_url(cushion, '')
  )
  sofa_GET(url, ...)
#
#   if(cushion$type=="localhost"){
#     sofa_GET(sprintf("http://127.0.0.1:%s", port), ...)
#   } else
#     if(cushion$type=="cloudant"){
#       auth <- get_pwd(username, pwd, "cloudant")
#       call_ <- sprintf('https://%s:%s@%s.cloudant.com', auth[[1]], auth[[2]], auth[[1]])
#       sofa_GET(call_, ...)
#     } else if(cushion$type=="iriscouch"){
#       auth <- get_pwd(username,pwd,"iriscouch")
#       sofa_GET(sprintf('https://%s.iriscouch.com', auth[[1]]), ...)
#     }
}
