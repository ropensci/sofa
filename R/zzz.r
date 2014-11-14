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

sofa_GET <- function(url, args = list(), as = 'list', ...){
  as <- match.arg(as, c('list','json'))
  res <- GET(url, query=args, ...)
  tt <- content(res, "text")
  if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_DELETE <- function(url, as = 'list',...){
  as <- match.arg(as, c('list','json'))
  res <- DELETE(url, ...)
  stop_for_status(res)
  tt <- content(res, "text")
  if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_PUT <- function(url, as = 'list', ...){
  as <- match.arg(as, c('list','json'))
  res <- PUT(url, ...)
  stop_for_status(res)
  tt <- content(res, "text")
  if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_POST <- function(url, as = 'list', ...){
  res <- POST(url, ...)
  stop_for_status(res)
  tt <- content(res, "text")
  if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

pick_url <- function(x){
  switch(x$type,
         localhost = sprintf("http://127.0.0.1:%s/", x$port),
         cloudant = cloudant_url(x),
         iriscouch = iris_url(x)
  )
}
