#' Put a cushion on the sofa, and get cushion info
#'
#' That is, set up config for remote CouchDB databases, or get auth info
#'
#' @name authentication
#' @param name Name for the cushion. This is what you'll call in sofa functions to get these
#' details.
#' @param user A user name
#' @param pwd A password
#' @param type One of localhost, cloudant, or iriscouch. This is what's used to determine
#' how to structure the URL to make the request.
#' @param port Port. Only applies when type is localhost.
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
#' options(cloudant = list(user='name', pwd='pwd'))
#'
#' Though if you don't want to store them permanently, you can use the cushion()
#' function instead. See examples below on how to do this. Though using cusion()
#' only stores them for the current session.
#'
#' \code{profile()} Looks first in the local environment SofaAuthCache, and if finds nothing,
#' looks in your \code{.Rprofile} file.
#' @examples \donttest{
#' cushion('cloudant', user='name', pwd='pwd', type="cloudant")
#' cushion('iriscouch', user='name', pwd='pwd', type="iriscouch")
#' cushion('julies_iris', user='name', pwd='pwd', type="iriscouch")
#'
#' cushion(localhost = list(type="localhost", port=5984))
#' profiles()
#' }

#' @export
#' @rdname authentication
cushion <- function(name, user=NULL, pwd=NULL, type, port=NULL){
  assign(name, list(user=user, pwd=pwd, type=type, port=port), envir = SofaAuthCache)
}

#' @export
#' @rdname authentication
profiles <- function()
{
  if(length(ls(SofaAuthCache)) == 0){
    vals <- names(.Options)
    temp <- .Options[grep('sofa', vals)]
  } else { temp <- mget(ls(SofaAuthCache), envir=SofaAuthCache) }
  if(length(temp) == 0)
    stop("No auth details found")
  else
    lapply(temp, function(x) structure(x, class="sofa_profiles"))
}

#' @export
print.sofa_profiles <- function(x, ...){
  cat("<sofa profile> ", sep = "\n")
  cat(paste0("   user : ", x$user), sep = "\n")
  cat(paste0("   pwd  : ", x$pwd), sep = "\n")
  cat(paste0("   type : ", x$type), sep = "\n")
  cat(paste0("   port : ", x$port), sep = "\n")
}

# sofa environment
SofaAuthCache <- new.env(hash=TRUE)

.onLoad <- function(...) {
  assign("localhost", list(user=NULL, pwd=NULL, type="localhost", port=5984), envir = SofaAuthCache)
}

get_cushion <- function(x){
  profs <- profiles()
  res <- profs[ names(profs) %in% x ]
  if(length(res) == 0) stop(paste0(x, " not found, see ?cushion and ?profiles")) else res[[1]]
}


# get_pwd <- function(u=NULL,p=NULL,service)
# {
#   auth <- profiles()
# #   ser <- paste0('sofa_',service)
#
#   if(is.null(u) | is.null(p)){
#     temp <- grep(service, names(auth))
#     if(identical(temp,integer(0)))
#       stop('Auth details not found')
#     username <- auth[temp][[1]][[1]]
#     pwd <- auth[temp][[1]][[2]]
#     out <- list(username,pwd)
#   }
#
#   if(is.null(username) | is.null(pwd))
#     stop("You must supply your username and password for Cloudant or Iriscouch\nOptionally, set your username and password in options, see vignette")
#
#   return(out)
# }
