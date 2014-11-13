#' Work with design documents (i.e., views) in your CouchDB's.
#'
#' @name views
#' @inheritParams ping
#' @param dbname Database name
#' @param design_name Design document name
#' @param fxnname A function name
#' @param key Key
#' @param value Value
#' @param query Query terms
#' @details If you are writing a complicated javascript function, better to do
#'    that in the Futon CouchDB interface or otherwise.
#' @examples \donttest{
#' # Create a view
#' view_put(dbname='alm_couchdb', design_name='almview1')
#' view_put(dbname='alm_couchdb', design_name='almview2', value="doc.baseurl")
#' view_put(dbname='alm_couchdb', design_name='almview5', value="[doc.baseurl,doc.queryargs]")
#'
#' # Delete a view
#' view_del(dbname='alm_couchdb', design_name='almview1')
#'
#' # Get info on a design document (i.e., a view)
#' view_get(dbname='alm_couchdb', design_name='almview1')
#'
#' # Search using a view
#' view_search(dbname='alm_couchdb', design_name='almview1', query="XXX")
#' }

#' @export
#' @rdname views
view_put <- function(dbname, design_name, fxnname='foo', key="null", value="doc",
  endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name)
  doc2 <- paste0('{"_id":',
           '"_design/', design_name, '",',
           '"views": {', '"', fxnname, '": {', '"map": "function(doc){emit(', key, ",", value, ')}"}}}')
  fromJSON(content(PUT(url=call_, body=doc2)))
}

#' @export
#' @rdname views
view_del <- function(dbname, design_name, endpoint="http://127.0.0.1", port=5984)
{
  rev <- view_get(dbname=dbname, design_name=design_name)$`_rev`
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name)
  content(DELETE(url=call_, query=list(rev=rev)))
}

#' @export
#' @rdname views
view_get <- function(dbname, design_name, endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name)
  fromJSON(content(GET(url=call_)))
}

#' @export
#' @rdname views
view_search <- function(dbname, design_name, query = NULL, endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste0(paste(endpoint, port, sep=":"), "/", dbname, "/_design/", design_name, "/_view", "/foo")
  fromJSON(content(GET(url=call_)))
}
