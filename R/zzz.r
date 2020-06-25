remote_url <- function(cushion, dbname=NULL, endpt=NULL){
  switch(cushion$type,
         cloudant = cloudant_url(cushion, dbname, endpt),
         iriscouch = iris_url(cushion, dbname, endpt))
}

cloudant_url <- function(cushion, dbname=NULL, endpt=NULL){
  if (is.null(dbname)) {
    paste(sprintf('https://%s:%s@%s.cloudant.com', cushion$user, cushion$pwd,
                  cushion$user), endpt, sep = "/")
  } else if (is.null(endpt)) {
    paste(sprintf('https://%s:%s@%s.cloudant.com', cushion$user, cushion$pwd,
                  cushion$user), dbname, sep = "/")
  } else {
    paste(sprintf('https://%s:%s@%s.cloudant.com', cushion$user, cushion$pwd,
                  cushion$user), dbname, endpt, sep = "/")
  }
}

iris_url <- function(cushion, dbname=NULL, endpt=NULL){
  if (is.null(dbname)) {
    paste(sprintf('https://%s.iriscouch.com', cushion$user), endpt, sep = "/")
  } else if (is.null(endpt)) {
    paste(sprintf('https://%s.iriscouch.com', cushion$user), dbname, sep = "/")
  } else {
    paste(sprintf('https://%s.iriscouch.com', cushion$user), dbname, endpt,
          sep = "/")
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

sofa_GET <- function(url, as = 'list', query = NULL, headers = NULL,
                     auth = NULL, disk = NULL, ...) {
  as <- match.arg(as, c('list', 'json', 'raw'))
  cli <- crul::HttpClient$new(url = url,
                              headers = c(ct_json, a_json, headers),
                              opts = sc(c(auth, list(...))))
  res <- cli$get(query = query)
  stop_status(res)
  tt <- res$parse("UTF-8")
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_GET_disk <- function(url, as = 'list', query = NULL, headers = NULL,
                     auth = NULL, disk, ...) {
  as <- match.arg(as, c('list', 'json', 'raw'))
  cli <- crul::HttpClient$new(url = url,
                              headers = c(ct_json, a_json, headers),
                              opts = sc(c(auth, list(...))))
  res <- cli$get(query = query, disk = disk)
  stop_status(res)
  res$content
}

sofa_HEAD <- function(url, headers = NULL, auth = NULL, ...) {
  cli <- crul::HttpClient$new(url = url,
                              headers = c(ct_json, a_json, headers),
                              opts = sc(c(auth, list(...))))
  res <- cli$head()
  stop_status(res)
  res$response_headers
}

sofa_DELETE <- function(url, as = 'list', headers = NULL, auth = NULL,
                        query = NULL, ...) {
  as <- match.arg(as, c('list','json'))
  cli <- crul::HttpClient$new(url = url, headers = headers,
                              opts = sc(c(auth, list(...))))
  res <- cli$delete(query = query)
  stop_status(res)
  tt <- res$parse("UTF-8")
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_PUT <- function(url, as = 'list', body = NULL,
                     encode = "json", headers = NULL, auth = NULL, ...) {

  as <- match.arg(as, c('list','json'))
  cli <- crul::HttpClient$new(
    url = url, headers = c(ct_json, a_json, headers),
    opts = sc(c(auth, list(...))))
  res <- cli$put(body = body, encode = encode)
  stop_status(res)
  tt <- res$parse("UTF-8")
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

sofa_POST <- function(url, as = 'list', body, encode, headers = NULL,
                      auth = NULL, query = NULL, ...) {
  cli <- crul::HttpClient$new(url = url,
                              headers = c(ct_json, a_json, headers),
                              opts = sc(c(auth, list(...))))
  res <- cli$post(body = body, query = query, encode = encode)
  stop_status(res)
  tt <- res$parse("UTF-8")
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

# sofa_COPY <- function(url, as = 'list', headers = NULL, ...) {
#   as <- match.arg(as, c('list','json'))
#   res <- VERB("COPY", url, content_type_json(), ...)
#   stop_status(res)
#   tt <- res$parse("UTF-8")
#   if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
# }

stop_status <- function(x) {
  if (x$status_code > 202) {
    body <- ""
    if (length(x$content) != 0) {
      body <- jsonlite::fromJSON(x$parse("UTF-8"), FALSE)$reason
      stop(sprintf("(%s) - %s", x$status_code, body), call. = FALSE)
    } else {
      x$raise_for_status()
    }
  }
}

`%||%` <- function(x, y) if (is.null(x)) y else x

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
        if (!tmp) stop(attr(tmp, "err"), call. = FALSE)
        x
      }
    } else if (is.list(x)) {
      jsonlite::toJSON(x, auto_unbox = TRUE, digits = getOption("digits") %||% 7)
    } else {
      stop("Only character and list types supported currently")
    }
  }
}

check_if <- function(x, class) {
  if (!inherits(x, class)) stop("input must be of class ", class, call. = FALSE)
}
assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
          paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

ct_json <- list(`Content-Type` = "application/json")
a_json <- list(Accept = "application/json")
