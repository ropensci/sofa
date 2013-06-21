#' Put a cushion on the sofa - i.e., set up config for remote CouchDB databases
#' 
#' @import httr
#' @param cloudant_name Cloudant username
#' @param cloudant_pwd Cloudant password
#' @param iriscouch_name Iriscouch username
#' @param iriscouch_pwd Iriscouch password
#' @examples \dontest{
#' cushion(cloudant_name='name', cloudant_pwd='pwd')
#' cushion(iriscouch_name='name', iriscouch_pwd='pwd')
#' }
#' @export
cushion <- function(cloudant_name=NULL, cloudant_pwd=NULL, 
                    iriscouch_name=NULL, iriscouch_pwd=NULL)
{
  options(cloudant.name=cloudant_name)
  options(cloudant.pwd=cloudant_pwd)
  options(iriscouch.name=iriscouch_name)
  options(iriscouch.pwd=iriscouch_pwd)
}

#' Put a pillow on the sofa - HMM, WHAT WOULD A PILLOW BE...
#'
# pillow <- function(endpoint, username, pwd){
#   
# }