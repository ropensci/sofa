# .onAttach <- function(...) {
#   packageStartupMessage("
#     Start CouchDB on your command line by typing 'couchdb'
#     New to sofa? Tutorial at https://github.com/sckott/sofa
#     Use suppressPackageStartupMessages() to suppress these startup messages in the future\n
#   ")
# }

remote_url <- function(cushion, dbname=NULL, endpt=NULL){
  switch(cushion$type,
         cloudant = cloudant_url(cushion, dbname, endpt),
         iriscouch = iris_url(cushion, dbname, endpt))
}

cloudant_url <- function(cushion, dbname=NULL, endpt=NULL){
  if(is.null(dbname)){
    paste(sprintf('https://%s:%s@%s.cloudant.com', cushion$user, cushion$pwd, cushion$user), endpt, sep="/")
  } else if(is.null(endpt)){
    paste(sprintf('https://%s:%s@%s.cloudant.com', cushion$user, cushion$pwd, cushion$user), dbname, sep="/")
  } else {
    paste(sprintf('https://%s:%s@%s.cloudant.com', cushion$user, cushion$pwd, cushion$user), dbname, endpt, sep="/")
  }
}

iris_url <- function(cushion, dbname=NULL, endpt=NULL){
  if(is.null(dbname)){
    paste(sprintf('https://%s.iriscouch.com', cushion$user), endpt, sep = "/")
  } else if(is.null(endpt)){
    paste(sprintf('https://%s.iriscouch.com', cushion$user), dbname, sep="/")
  } else {
    paste(sprintf('https://%s.iriscouch.com', cushion$user), dbname, endpt, sep = "/")
  }
}

sc <- function (l) Filter(Negate(is.null), l)

sofa_GET <- function(url, args = list(), ...){
  res <- GET(url, query=args, ...)
  jsonlite::fromJSON(content(res, "text"), FALSE)
}

sofa_DELETE <- function(url, ...){
  res <- DELETE(url, ...)
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text"), FALSE)
}

sofa_PUT <- function(url, ...){
  res <- PUT(url, ...)
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text"), FALSE)
}

sofa_POST <- function(url, ...){
  res <- POST(url, ...)
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text"), FALSE)
}

pick_url <- function(x){
  switch(x$type,
         localhost = paste0("http://127.0.0.1:", x$port),
         cloudant = cloudant_url(x),
         iriscouch = iris_url(x)
  )
}
