# sofa environment
SofaAuthCache <- new.env(hash=TRUE)

.onAttach <- function(...) {
  packageStartupMessage("
    \nStart CouchDB on your command line by typing 'couchdb' 
    \nThen start Elasticsearch if using by opening a new terminal tab/window, navigating to where it was installed and starting 
    \nOn my Mac this is: cd /usr/local/elasticsearch then bin/elasticsearch -f
    \nNew to sofa? Tutorial at https://github.com/sckott/sofa. 
    \nUse suppressPackageStartupMessages() to suppress these startup messages in the future\n
  ")
} 

#' Get auth info for a cushion
#' @param u username
#' @param p password
#' @param service one of iriscouch, cloudant, etc.
#' @export
#' @examples \dontrun{
#' get_pwd(service='cloudant')
#' }
get_pwd <- function(u=NULL,p=NULL,service)
{  
  auth <- sofa_profile()
#   ser <- paste0('sofa_',service)
  
  if(is.null(u) | is.null(p)){
    temp <- grep(service,names(auth))
    if(identical(temp,integer(0)))
      stop('Auth details for sofa_cloudant not found')
    username <- auth[temp][[1]][[1]]
    pwd <- auth[temp][[1]][[2]]
    out <- list(username,pwd)
  }
  
  if(is.null(username) | is.null(pwd))
    stop("You must supply your username and password for Cloudant or Iriscouch\nOptionally, set your username and password in options, see vignette")
  
  return(out)
}

# get_pwd <- function(u,p,service)
# {  
#   if(is.null(u) | is.null(p)){
#     if(service == "cloudant"){
#       username <- getOption("cloudant.name")
#       pwd <- getOption("cloudant.pwd")
#       out <- list(username,pwd)
#     } else
#       if(service == "iriscouch"){
#         username <- getOption("iriscouch.name")
#         pwd <- getOption("iriscouch.pwd")
#         out <- list(username,pwd)
#       }
#     if(is.null(username) | is.null(pwd))
#       stop("You must supply your username and password for Cloudant or Iriscouch\nOptionally, set your username and password in options, see vignette")
#   }
#   return(out)
# }
# 
# #' get_pwd(service='cloudant')
# get_pwd <- function(u=NULL,p=NULL,service)
# {  
#   auth <- sofa_profile()
#   if(is.null(u) | is.null(p)){
#     if(service == "cloudant"){
#       temp <- grep('sofa_cloudant',names(auth))
#       if(identical(temp,integer(0)))
#         stop('Auth details for sofa_cloudant not found')
#       username <- auth[temp][[1]][[1]]
#       pwd <- auth[temp][[1]][[2]]
#       out <- list(username,pwd)
#     } else
#       if(service == "iriscouch"){
#         temp <- grep('sofa_iriscouch',names(auth))
#         if(identical(temp,integer(0)))
#           stop('Auth details for sofa_iriscouch not found')
#         username <- auth[temp][[1]][[1]]
#         pwd <- auth[temp][[1]][[2]]
#         out <- list(username,pwd)
#       }
#     if(is.null(username) | is.null(pwd))
#       stop("You must supply your username and password for Cloudant or Iriscouch\nOptionally, set your username and password in options, see vignette")
#   }
#   return(out)
# }