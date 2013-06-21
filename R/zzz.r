.onAttach <- function(...) {
  packageStartupMessage("
    \nStart CouchDB on your command line by typing 'couchdb' 
    \nThen start Elasticsearch if using by opening a new terminal tab/window, navigating to where it was installed and starting 
    \nOn my Mac this is: cd /usr/local/elasticsearch then bin/elasticsearch -f
    \nNew to sofa? Tutorial at https://github.com/schamberlain/sofa. 
    \nUse suppressPackageStartupMessages() to suppress these startup messages in the future\n
  ")
} 

#' Get auth info for a cushion
#' @param u username
#' @param p password
#' @param service one of iriscouch, cloudant, etc.
#' @export
get_pwd <- function(u,p,service)
{  
  if(is.null(u) | is.null(p)){
    if(service == "cloudant"){
      username <- getOption("cloudant.name")
      pwd <- getOption("cloudant.pwd")
      out <- list(username,pwd)
    } else
      if(service == "iriscouch"){
        username <- getOption("iriscouch.name")
        pwd <- getOption("iriscouch.pwd")
        out <- list(username,pwd)
      }
    if(is.null(username) | is.null(pwd))
      stop("You must supply your username and password for Cloudant or Iriscouch\nOptionally, set your username and password in options, see vignette")
  }
  return(out)
}