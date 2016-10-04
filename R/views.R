#' Work with design documents (i.e., views) in your CouchDB's.
#'
#' @name views
#' @inheritParams ping
#' @param dbname (character) Database name. required.
#' @param design_name (character) Design document name. required.
#' @param fxnname (character) A function name. required for \code{view_put}
#' and \code{view_put_}
#' @param key,value (character) a key and value, see Examples and Details
#' @param fxn (character) a javascript function. required for \code{view_put_}
#' @details \code{view_create} is a slightly easier interface to creating
#' design documents; it just asks for a function name, the key and a
#' value, then we create the function for you internally. TO have more
#' flexibility use \code{view_put_} (with underscore on the end) to write the
#' function yourself.
#' @examples \dontrun{
#' (x <- Cushion$new())
#'
#' file <- system.file("examples/omdb.json", package = "sofa")
#' strs <- readLines(file)
#'
#' ## create a database
#' if ("omdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="omdb"))
#' }
#' db_create(x, dbname='omdb')
#'
#' ## add the documents
#' invisible(db_bulk_create(x, "omdb", strs))
#'
#' # Create a view, the easy way, but less flexible
#' view_create(x, dbname='omdb', design_name='view1', fxnname="foobar1")
#' view_create(x, dbname='omdb', design_name='view2', fxnname="foobar2",
#'   value="doc.Country")
#' view_create(x, dbname='omdb', design_name='view5', fxnname="foobar3",
#'   value="[doc.Country,doc.imdbRating]")
#'
#' # the harder way, write your own function, but more flexible
#' view_create_(x, dbname='omdb', design_name='view2',
#'   fxnname = "stuffthings", fxn = "function(doc){emit(null,doc.Country)}")
#'
#' # Delete a view
#' view_delete(x, dbname='omdb', design_name='view1')
#'
#' # Get info on a design document (i.e., a view)
#' view_get(x, dbname='omdb', design_name='view2')
#' view_get(x, dbname='omdb', design_name='view5')
#'
#' # Search using a view
#' res <- view_search(x, dbname='omdb', design_name='view2')
#' head(
#'   do.call(
#'     "rbind.data.frame",
#'     lapply(res$rows, function(x) Filter(length, x))
#'   )
#' )
#'
#' res <- view_search(x, dbname='omdb', design_name='view5')
#' head(
#'   structure(do.call(
#'     "rbind.data.frame",
#'     lapply(res$rows, function(x) x$value)
#'   ), .Names = c('Country', 'imdbRating'))
#' )
#' }

#' @export
#' @rdname views
view_create <- function(cushion, dbname, design_name, fxnname, key = "null",
                     value = "doc", as = 'list', ...) {
  fxn <- paste0('function(doc){emit(', key, ",", value, ')}')
  view_create_(cushion, dbname, design_name, fxnname, fxn, as, ...)
}

#' @export
#' @rdname views
view_create_ <- function(cushion, dbname, design_name, fxnname, fxn, as = 'list', ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  call_ <- file.path(url, dbname, "_design", design_name)
  doc2 <- paste0('{"_id":',
                 '"_design/', design_name, '",',
                 '"views": {', '"', fxnname,
                 '": {', '"map":"', fxn ,'"}}}')
  sofa_PUT(call_, as, body = doc2, cushion$get_headers(), ...)
}

#' @export
#' @rdname views
view_delete <- function(cushion, dbname, design_name, as='list', ...) {
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
view_search <- function(cushion, dbname, design_name, as='list', ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  call_ <- file.path(url, dbname, "_design", design_name, "_view", "foo")
  sofa_GET(call_, as, cushion$get_headers(), ...)
}
