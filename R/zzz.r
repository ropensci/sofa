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

sc <- function(l) Filter(Negate(is.null), l)

asl <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    if (x) 'true' else 'false'
  }
}

sofa_GET <- function(url, as = 'list', ...) {
  as <- match.arg(as, c('list','json'))
  res <- GET(url, content_type_json(), ...)
  stop_status(res)
  tt <- contt(res)
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_DELETE <- function(url, as = 'list', ...) {
  as <- match.arg(as, c('list','json'))
  res <- DELETE(url, content_type_json(), ...)
  stop_status(res)
  tt <- contt(res)
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_PUT <- function(url, as = 'list', ...){
  as <- match.arg(as, c('list','json'))
  res <- PUT(url, content_type_json(), ...)
  stop_status(res)
  tt <- contt(res)
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_POST <- function(url, as = 'list', ...) {
  res <- POST(url, content_type_json(), ...)
  stop_status(res)
  tt <- contt(res)
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_COPY <- function(url, as = 'list', ...) {
  as <- match.arg(as, c('list','json'))
  res <- VERB("COPY", url, content_type_json(), ...)
  stop_status(res)
  tt <- contt(res)
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

stop_status <- function(x) {
  if (x$status_code > 202) {
    stop(sprintf("(%s) - %s",
                 x$status_code,
                 jsonlite::fromJSON(content(x, "text", encoding = "UTF-8"), FALSE)$reason),
         call. = FALSE)
  }
}

contt <- function(x) {
  httr::content(x, "text", encoding = "UTF-8")
}

# sofa_GET <- function(url, as = 'list', ...) sofa_verb("GET", url, as, ...)
# sofa_DELETE <- function(url, as = 'list', ...) sofa_verb("DELETE", url, as, ...)
# sofa_PUT <- function(url, as = 'list', ...) sofa_verb("PUT", url, as, ...)
# sofa_POST <- function(url, as = 'list', ...) sofa_verb("POST", url, as, ...)
# sofa_COPY <- function(url, as = 'list', ...) sofa_verb("COPY", url, as, ...)
#
# sofa_verb <- function(verb, url, as = 'list',...){
#   as <- match.arg(as, c('list','json'))
#   res <- VERB(verb, url, content_type_json(), ...)
#   stop_for_status(res)
#   tt <- content(res, "text")
#   if(as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
# }

check_inputs <- function(x){
  if (length(x) == 0) {
    NULL
  } else {
    if (is.character(x)) {
      # replace newlines
      x <- gsub("\n|\r", "", x)
      # check if text is likely XML
      if (grepl("<[A-Za-z]+>", x)) {
        paste('{"xml":', '"', x, '"', '}', sep = "")
      } else {
        # validate
        tmp <- jsonlite::validate(x)
        if (!tmp) stop(attr(tmp, "err"))
        x
      }
    } else if (is.list(x)) {
      jsonlite::toJSON(x, auto_unbox = TRUE)
    } else {
      stop("Only character and list types supported currently")
    }
  }
}
