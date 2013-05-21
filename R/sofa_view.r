#' Put a design document (i.e., a view) into your CouchDB database.
#' 
#' @import httr RJSONIO
#' @inheritParams sofa_ping
#' @param dbname Database name
#' @param design_name Design document name
#' @details If you are writing a complicated javascript function, better to do 
#'    that in the Futon CouchDB interface or otherwise. 
#' @examples \dontrun{
#' sofa_view_put(dbname='alm_couchdb', design_name='almview1')
#' sofa_view_put(dbname='alm_couchdb', design_name='almview2', value="doc.baseurl")
#' sofa_view_put(dbname='alm_couchdb', design_name='almview5', value="[doc.baseurl,doc.queryargs]")
#' }
#' @export
sofa_view_put <- function(dbname, design_name, fxnname='foo', key="null", value="doc", endpoint="http://127.0.0.1", port=5984)
{ 
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name)
  doc2 <- paste0('{"_id":', 
           '"_design/', design_name, '",', 
           '"views": {', '"', fxnname, '": {', '"map": "function(doc){emit(', key, ",", value, ')}"}}}')
  fromJSON(content(PUT(url=call_, body=doc2)))
}

#' Delete a design document from your CouchDB database.
#' 
#' @import httr
#' @inheritParams sofa_ping
#' @param dbname Database name
#' @param design_name Design document name
#' @examples \dontrun{
#' sofa_view_del(dbname='alm_couchdb', design_name='almview1')
#' }
#' @export
sofa_view_del <- function(dbname, design_name, endpoint="http://127.0.0.1", port=5984)
{
  rev <- sofa_view_get(dbname=dbname, design_name=design_name)$`_rev`
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name)
  content(DELETE(url=call_, query=list(rev=rev)))
}

#' Get info on a design document (i.e., a view) in your CouchDB database.
#' 
#' @import httr
#' @inheritParams sofa_ping
#' @param dbname Database name
#' @param design_name Design document name
#' @examples \dontrun{
#' sofa_view_get(dbname='alm_couchdb', design_name='almview1')
#' }
#' @export
sofa_view_get <- function(dbname, design_name, endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name)
  fromJSON(content(GET(url=call_)))
}

#' Search your CouchDB database using a view.
#' 
#' @import httr
#' @inheritParams sofa_ping
#' @param dbname Database name
#' @param design_name Design document name
#' @param query Query terms
#' @examples \dontrun{
#' sofa_view_search(dbname='alm_couchdb', design_name='almview1', query="XXX")
#' }
#' @export
sofa_view_search <- function(dbname, design_name, query = NULL, endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name, "/_view", "/foo")
#   args <- list(...)
  fromJSON(content(GET(url=call_)))
}