#' Work with design documents
#'
#' @name design
#' @template all
#' @template return
#' @param dbname (character) Database name. required.
#' @param design (character) Design document name. this is the design name
#' without `_design/`, which is prepended internally. required.
#' @param fxnname (character) A function name. required for `view_put`
#' and `view_put_`
#' @param key,value (character) a key and value, see Examples and Details
#' @param fxn (character) a javascript function. required for `view_put_`
#' @details `design_create` is a slightly easier interface to creating
#' design documents; it just asks for a function name, the key and a
#' value, then we create the function for you internally. TO have more
#' flexibility use `view_put_` (with underscore on the end) to write the
#' function yourself.
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user = user, pwd = pwd))
#'
#' file <- system.file("examples/omdb.json", package = "sofa")
#' strs <- readLines(file)
#'
#' ## create a database
#' if ("omdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname = "omdb"))
#' }
#' db_create(x, dbname = "omdb")
#'
#' ## add the documents
#' invisible(db_bulk_create(x, "omdb", strs))
#'
#' # Create a view, the easy way, but less flexible
#' design_create(x, dbname = "omdb", design = "view1", fxnname = "foobar1")
#' design_create(x,
#'   dbname = "omdb", design = "view2", fxnname = "foobar2",
#'   value = "doc.Country"
#' )
#' design_create(x,
#'   dbname = "omdb", design = "view5", fxnname = "foobar3",
#'   value = "[doc.Country,doc.imdbRating]"
#' )
#'
#' # the harder way, write your own function, but more flexible
#' design_create_(x,
#'   dbname = "omdb", design = "view22",
#'   fxnname = "stuffthings", fxn = "function(doc){emit(null,doc.Country)}"
#' )
#'
#' # Delete a view
#' design_delete(x, dbname = "omdb", design = "view1")
#'
#' # Get info on a design document
#' ## HEAD request, returns just response headers
#' design_head(x, dbname = "omdb", design = "view2")
#' design_head(x, dbname = "omdb", design = "view5")
#' ## GET request, returns information about the design document
#' design_info(x, dbname = "omdb", design = "view2")
#' design_info(x, dbname = "omdb", design = "view5")
#'
#' # Get a design document (GET request)
#' design_get(x, dbname = "omdb", design = "view2")
#' design_get(x, dbname = "omdb", design = "view5")
#'
#' # Search using a view
#' res <- design_search(x, dbname = "omdb", design = "view2", view = "foobar2")
#' head(
#'   do.call(
#'     "rbind.data.frame",
#'     lapply(res$rows, function(x) Filter(length, x))
#'   )
#' )
#'
#' res <- design_search(x, dbname = "omdb", design = "view5", view = "foobar3")
#' head(
#'   structure(do.call(
#'     "rbind.data.frame",
#'     lapply(res$rows, function(x) x$value)
#'   ), .Names = c("Country", "imdbRating"))
#' )
#' }

#' @export
#' @rdname design
design_create <- function(cushion, dbname, design, fxnname, key = "null",
                          value = "doc", as = "list", ...) {
  fxn <- paste0("function(doc){emit(", key, ",", value, ")}")
  design_create_(cushion, dbname, design, fxnname, fxn, as, ...)
}

#' @export
#' @rdname design
design_create_ <- function(cushion, dbname, design, fxnname, fxn, as = "list", ...) {
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), dbname, "_design", design)
  doc2 <- paste0(
    '{"_id":',
    '"_design/', design, '",',
    '"views": {', '"', fxnname,
    '": {', '"map":"', fxn, '"}}}'
  )
  sofa_PUT(url, as,
    body = doc2,
    headers = cushion$get_headers(), auth = cushion$get_auth(), ...
  )
}

#' @export
#' @rdname design
design_delete <- function(cushion, dbname, design, as = "list", ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  rev <- design_get(cushion, dbname, design)$`_rev`
  call_ <- file.path(url, dbname, "_design", design)
  sofa_DELETE(call_, as,
    query = list(rev = rev), cushion$get_headers(),
    cushion$get_auth(), ...
  )
}

#' @export
#' @rdname design
design_get <- function(cushion, dbname, design, as = "list", ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  sofa_GET(
    file.path(url, dbname, "_design", design), as, NULL,
    cushion$get_headers(), cushion$get_auth(), ...
  )
}

#' @export
#' @rdname design
design_head <- function(cushion, dbname, design, ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  sofa_HEAD(
    file.path(url, dbname, "_design", design),
    cushion$get_headers(), cushion$get_auth(), ...
  )
}

#' @export
#' @rdname design
design_info <- function(cushion, dbname, design, ...) {
  check_cushion(cushion)
  url <- cushion$make_url()
  sofa_GET(file.path(url, dbname, "_design", design, "_info"),
    headers = cushion$get_headers(), auth = cushion$get_auth(), ...
  )
}

# design_copy <- function(cushion, dbname, design, design_to, as='list', ...) {
#   check_cushion(cushion)
#   url <- cushion$make_url()
#   call_ <- file.path(url, dbname, "_design", design)
#   sofa_COPY(call_, as, cushion$get_headers(),
#             add_headers(DESTINATION = paste0("_design/", design_to)), ...)
# }
