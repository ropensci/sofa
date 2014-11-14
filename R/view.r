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
view_put <- function(cushion="localhost", dbname, design_name, fxnname='foo',
  key="null", value="doc", ...)
{
  cushion <- get_cushion(cushion)
  url <- pick_url(cushion)
  call_ <- paste0(url, "/", dbname, "/_design/", design_name)
  doc2 <- paste0('{"_id":',
           '"_design/', design_name, '",',
           '"views": {', '"', fxnname, '": {', '"map": "function(doc){emit(', key, ",", value, ')}"}}}')
  sofa_PUT(call_, body=doc2, ...)
}

#' @export
#' @rdname views
view_del <- function(cushion="localhost", dbname, design_name, ...)
{
  cushion <- get_cushion(cushion)
  url <- pick_url(cushion)
  rev <- view_get(cushion, dbname, design_name)$`_rev`
  call_ <- paste0(url, "/", dbname, "/_design/", design_name)
  sofa_DELETE(call_, query=list(rev=rev), ...)
}

#' @export
#' @rdname views
view_get <- function(cushion="localhost", dbname, design_name, ...)
{
  cushion <- get_cushion(cushion)
  url <- pick_url(cushion)
  sofa_GET(paste0(url, "/", dbname, "/_design/", design_name), ...)
}

#' @export
#' @rdname views
view_search <- function(cushion="localhost", dbname, design_name, query = NULL, ...)
{
  cushion <- get_cushion(cushion)
  url <- pick_url(cushion)
  call_ <- paste0(url, "/", dbname, "/_design/", design_name, "/_view", "/foo")
  sofa_GET(call_, ...)
}
