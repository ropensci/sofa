#' Prints the raw results of the call.
#' 
#' @param x input
#' @param ... more stuff
#' @export
#' @examples
#' results <- elasticsearch(dbname="rplos_db", q="scienceseeker")
#' rawdata(results)
rawdata <- function(x, ...) UseMethod("rawdata")

#' @S3method rawdata sofaes
rawdata.sofaes <- function(x){
  if(!is.sofaes(x))
    stop("Input is not of class sofaes")  
  theoutput <- llply(shit$hits, function(x) x$`_source`$response)
  return( theoutput )
}

#' Print summary of results
#' @method summary sofaes
#' @S3method summary sofaes
#' @export
summary.sofaes <- function(x){
  if(!is.sofaes(x))
    stop("Input is not of class sofaes")
  
  docsids <- sapply(x$hits$hits, function(x) x$`_source`$`_id`) # get the document IDs
  revs <- sapply(x$hits$hits, function(x) x$`_source`$`_rev`)
  qargs <- sapply(x$hits$hits, function(x) fromJSON(x$`_source`$queryargs)) # get query arguments
  burl <- sapply(x$hits$hits, function(x) x$`_source`$baseurl) # get the base url
  
  return( list(document_details = data.frame(document_id=docsids, doc_rev=revs),
               base_url = burl,
               query_arguments = t(qargs)) )
}

#' Check if object is of class sofaes 
#' @param x input
#' @export
is.sofaes <- function(x) inherits(x, "sofaes")