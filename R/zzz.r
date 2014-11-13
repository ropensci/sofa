# sofa environment
SofaAuthCache <- new.env(hash=TRUE)

.onAttach <- function(...) {
  packageStartupMessage("
    Start CouchDB on your command line by typing 'couchdb'
    New to sofa? Tutorial at https://github.com/sckott/sofa
    Use suppressPackageStartupMessages() to suppress these startup messages in the future\n
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
  auth <- profile()
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

sc <- function (l) Filter(Negate(is.null), l)

sofa_GET <- function(url, args = list(), ...){
  tt <- GET(url, query=args, ...)
  res <- content(tt, "text")
  jsonlite::fromJSON(res, FALSE)
}

sofa_DELETE <- function(url, ...){
  res <- DELETE(url, ...)
  stop_for_status(res)
  content(res)
}

sofa_PUT <- function(url, ...){
  res <- PUT(url, ...)
  stop_for_status(res)
  content(res)
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
#   auth <- profile()
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
