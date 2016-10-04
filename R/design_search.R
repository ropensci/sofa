#' Search design documents
#'
#' @export
#' @inheritParams ping
#' @param dbname (character) Database name. required.
#' @param design (character) Design document name. this is the design name
#' without \strong{_design/}, which is prepended internally. required.
#' @param view (character) a view, same as \code{fxn} param in
#' \code{\link{design_create_}}. required.
#' @param conflicts (logical) Includes conflicts information in response.
#' Ignored if include_docs isn't \code{TRUE}. Default: \code{FALSE}
#' @param descending (logical) Return the documents in descending by key
#' order. Default: \code{FALSE}
#' @param endkey,end_key (list) Stop returning records when the specified key is
#' reached. Optional. \code{end_key} is an alias for \code{endkey}
#' @param endkey_docid,end_key_doc_id (character) Stop returning records when
#' the specified document ID is reached. Requires endkey to be specified for
#' this to have any effect. Optional. \code{end_key_doc_id} is an alias for
#' \code{endkey_docid}
#' @param group (logical) Group the results using the reduce function to a
#' group or single row. Default: \code{FALSE}
#' @param group_level (integer) Specify the group level to be used. Optional
#' @param include_docs (logical) Include the associated document with each
#' row. Default: \code{FALSE}.
#' @param attachments (logical) Include the Base64-encoded content of
#' attachments in the documents that are included if include_docs is
#' \code{TRUE}. Ignored if include_docs isn't \code{TRUE}.
#' Default: \code{FALSE}
#' @param att_encoding_info (logical) Include encoding information in
#' attachment stubs if include_docs is \code{TRUE} and the particular
#' attachment is compressed. Ignored if include_docs isn't \code{TRUE}.
#' Default: \code{FALSE}.
#' @param inclusive_end (logical) Specifies whether the specified end key
#' should be included in the result. Default: \code{TRUE}
#' @param key (list) Return only documents that match the specified
#' key. Optional
#' @param keys (list) Return only documents where the key matches one of the
#' keys specified in the array. Optional
#' @param limit (integer) Limit the number of the returned documents to the
#' specified number. Optional
#' @param reduce (logical)  Use the reduction function. Default: \code{TRUE}
#' @param skip (integer)  Skip this number of records before starting to
#' return the results. Default: 0
#' @param sorted (logical)  Sort returned rows (see Sorting Returned Rows).
#' Setting this to \code{FALSE} offers a performance boost. The total_rows
#' and offset fields are not available when this is set to \code{FALSE}.
#' Default: \code{TRUE}
#' @param stale (character) Allow the results from a stale view to be used.
#' Supported values: ok and update_after. Optional
#' @param startkey,start_key (list) Return records starting with the specified
#' key. Optional. \code{start_key} is an alias for startkey
#' @param startkey_docid,start_key_doc_id (character) Return records starting
#' with the specified document ID. Requires startkey to be specified for this
#' to have any effect. Optional. \codde{start_key_doc_id} is an alias for
#' \code{startkey_docid}
#' @param update_seq (logical) Response includes an update_seq value
#' indicating which sequence id of the database the view reflects.
#' Default: \code{FALSE}
#'
#' @references \url{http://docs.couchdb.org/en/latest/api/ddoc/views.html}
#'
#' @details Note that we only support GET for this method, and not POST.
#' Let us know if you want POST support
#'
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
#' design_create(x, dbname='omdb', design='view1', fxnname="foobar1")
#' design_create(x, dbname='omdb', design='view2', fxnname="foobar2",
#'   value="doc.Country")
#' design_create(x, dbname='omdb', design='view5', fxnname="foobar3",
#'   value="[doc.Country,doc.imdbRating]")
#'
#' # Search using a view
#' compact <- function(l) Filter(Negate(is.null), l)
#' res <- design_search(x, dbname='omdb', design='view2', view ='foobar2')
#' head(
#'   do.call(
#'     "rbind.data.frame",
#'     Filter(
#'       function(z) length(z) == 2,
#'       lapply(res$rows, function(x) compact(x[names(x) %in% c('id', 'value')]))
#'     )
#'   )
#' )
#'
#' res <- design_search(x, dbname='omdb', design='view5', view = 'foobar3')
#' head(
#'   structure(do.call(
#'     "rbind.data.frame",
#'     lapply(res$rows, function(x) x$value)
#'   ), .Names = c('Country', 'imdbRating'))
#' )
#'
#' # query parameters
#' ## limit
#' design_search(x, dbname='omdb', design='view5', view = 'foobar3',
#'   limit = 5)
#' }
design_search <- function(cushion, dbname, design, view, conflicts = NULL,
  descending = NULL, endkey = NULL, end_key = NULL, endkey_docid = NULL,
  end_key_doc_id = NULL, group = NULL, group_level = NULL, include_docs = NULL,
  attachments = NULL, att_encoding_info = NULL, inclusive_end = NULL,
  key = NULL, keys = NULL, limit = NULL, reduce = NULL, skip = NULL,
  sorted = NULL, stale = NULL, startkey = NULL, start_key = NULL,
  startkey_docid = NULL, start_key_doc_id = NULL, update_seq = NULL,
  as = 'list', ...) {

  check_cushion(cushion)
  url <- cushion$make_url()
  call_ <- file.path(url, dbname, "_design", design, "_view", view)
  args <- sc(list(
    conflicts = conflicts, descending = descending, endkey = endkey,
    end_key = end_key, endkey_docid = endkey_docid,
    end_key_doc_id = end_key_doc_id, group = group, group_level = group_level,
    include_docs = include_docs, attachments = attachments,
    att_encoding_info = att_encoding_info, inclusive_end = inclusive_end,
    key = key, keys = keys, limit = limit, reduce = reduce, skip = skip,
    sorted = sorted, stale = stale, startkey = startkey, start_key = start_key,
    startkey_docid = startkey_docid, start_key_doc_id = start_key_doc_id,
    update_seq = update_seq
  ))
  sofa_GET(call_, as, query = args, cushion$get_headers(), ...)
}
