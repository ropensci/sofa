#' Work with design documents (i.e., views) in your CouchDB's.
#'
#' @name views
#' @inheritParams ping
#' @param dbname (character) Database name
#' @param design_name (character) Design document name
#' @param fxnname (character) A function name
#' @param key (character) Key
#' @param value (character) Value
#' @param query (character) Query terms
#' @details If you are writing a complicated javascript function, better to do
#' that in the Futon CouchDB interface or otherwise.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' if ("acouch" %in% db_list(x)) {
#'  db_delete(x, dbname = "acouch")
#' }
#' db_create(x, 'acouch')
#'
#' # Create a view
#' view_put(x, dbname='acouch', design_name='view1')
#' view_put(x, dbname='acouch', design_name='view2', value="doc.baseurl")
#' view_put(x, dbname='acouch', design_name='view5', value="[doc.baseurl,doc.queryargs]")
#'
#' # Delete a view
#' view_delete(x, dbname='acouch', design_name='view1')
#'
#' # Get info on a design document (i.e., a view)
#' view_get(x, dbname='acouch', design_name='view2')
#'
#' # Search using a view
#' view_search(x, dbname='acouch', design_name='view2', query="XXX")
#' }

#' @export
#' @rdname views
view_put <- function(cushion, dbname, design_name, fxnname='foo',
  key="null", value="doc", as='json', ...) {

  check_cushion(cushion)
  url <- cushion$make_url()
  call_ <- file.path(url, dbname, "_design", design_name)
  doc2 <- paste0('{"_id":',
           '"_design/', design_name, '",',
           '"views": {', '"', fxnname, '": {', '"map": "function(doc){emit(', key, ",", value, ')}"}}}')
  sofa_PUT(call_, as, body = doc2, cushion$get_headers(), ...)
}

#' @export
#' @rdname views
view_delete <- function(cushion, dbname, design_name, as='json', ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  rev <- view_get(cushion, dbname, design_name)$`_rev`
  call_ <- file.path(url, dbname, "_design", design_name)
  sofa_DELETE(call_, as, query = list(rev = rev), cushion$get_headers(), ...)
}

#' @export
#' @rdname views
view_get <- function(cushion, dbname, design_name, as='list', ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  sofa_GET(file.path(url, dbname, "_design", design_name), as, cushion$get_headers(), ...)
}

#' @export
#' @rdname views
view_search <- function(cushion, dbname, design_name, query = NULL, as='json', ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  call_ <- file.path(url, dbname, "_design", design_name, "_view", "foo")
  sofa_GET(call_, as, cushion$get_headers(), ...)
}
