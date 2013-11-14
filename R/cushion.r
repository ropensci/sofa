#' Put a cushion on the sofa - i.e., set up config for remote CouchDB databases
#' 
#' @import httr
#' @param ... Enter named sets of username and password. 
#' @details Setup for authentication:
#' For localhost you don't need to authenticate, but of course you may have set 
#' up a username and password in which case use 'localhost'.
#' 
#' Others supported are 'cloudant' and 'iriscouch'.
#' 
#' You can use other named username/password sets too. 
#' 
#' You can permanently store your auth details in your .Rprofile by putting in 
#' entries like this: 
#' 
#' options(sofa_cloudant = c("username","yourcoolpassword"))
#' 
#' Though if you don't want to store them permanently, you can use the cushion() 
#' function instead. See examples below on how to do this. Though using cusion() 
#' only stores them for the current session. 
#' @examples \dontest{
#' cushion(sofa_cloudant=c('name','pwd'), sofa_iriscouch=c('name','pwd'))
#' }
#' @export
cushion <- function(...)
{
  auth <- list(...)
  if(is.null(auth)) stop("You must enter values for auth")
  for(i in seq_along(auth)){
    assign(names(auth[i]), auth[[i]], envir = sofa:::SofaAuthCache)
  }
}

#' Get auth information
#' @details 
#' Looks first in the local environment SofaAuthCache, and if finds nothing, looks
#' in your .Rprofile file.
#' @examples \dontest{
#' sofa_profile()
#' }
#' @export
sofa_profile <- function()
{
  if(length(ls(sofa:::SofaAuthCache)) == 0){
    vals <- names(.Options)
    temp <- .Options[grep('sofa', vals)]
  } else
  {
    temp <- mget(ls(sofa:::SofaAuthCache), envir=sofa:::SofaAuthCache)
  }
  if(length(temp)==0)
    stop("No auth details found")
  else
    temp
}