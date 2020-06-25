#' Work with attachments
#'
#' @name attachments
#' @template all
#' @template return
#' @param dbname (character) Database name. Required.
#' @param docid (character) Document ID. Required.
#' @param attachment (character) A file name. Required.
#' @param attname (character) Attachment name. Required.
#' @param type (character) one of raw (default) or text. required.
#' @details Methods:
#'
#' - `doc_attach_create` - create an attachment
#' - `doc_attach_info` - get info (headers) for an attachment
#' - `doc_attach_get` - get an attachment. this method does not attempt
#'  to read the object into R, but only gets the raw bytes or plain
#'  text. See examples for how to read some attachment types
#' - `doc_attach_delete` - delete and attachment
#'
#' @examples \dontrun{
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' if ("drinksdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="drinksdb"))
#' }
#' db_create(x, dbname='drinksdb')
#'
#' # create an attachment on an existing document
#' ## create a document first
#' doc <- '{"name":"stuff", "drink":"soda"}'
#' doc_create(x, dbname="drinksdb", doc=doc, docid="asoda")
#'
#' ## create a csv attachment
#' row.names(mtcars) <- NULL
#' file <- tempfile(fileext = ".csv")
#' write.csv(mtcars, file = file, row.names = FALSE)
#' doc_attach_create(x, dbname="drinksdb", docid="asoda",
#'   attachment=file, attname="mtcarstable.csv")
#'
#' ## create a binary (png) attachment
#' file <- tempfile(fileext = ".png")
#' png(file)
#' plot(1:10)
#' dev.off()
#' doc_attach_create(x, dbname="drinksdb", docid="asoda",
#'   attachment=file, attname="img.png")
#'
#' ## create a binary (pdf) attachment
#' file <- tempfile(fileext = ".pdf")
#' pdf(file)
#' plot(1:10)
#' dev.off()
#' doc_attach_create(x, dbname="drinksdb", docid="asoda",
#'   attachment=file, attname="plot.pdf")
#'
#' # get info for an attachment (HEAD request)
#' doc_attach_info(x, "drinksdb", docid="asoda", attname="mtcarstable.csv")
#' doc_attach_info(x, "drinksdb", docid="asoda", attname="img.png")
#' doc_attach_info(x, "drinksdb", docid="asoda", attname="plot.pdf")
#'
#' # get an attachment (GET request)
#' res <- doc_attach_get(x, "drinksdb", docid="asoda",
#'   attname="mtcarstable.csv", as = "text")
#' read.csv(text = res)
#' doc_attach_get(x, "drinksdb", docid="asoda", attname="img.png")
#' doc_attach_get(x, "drinksdb", docid="asoda", attname="plot.pdf")
#'
#' # delete an attachment
#' doc_attach_delete(x, "drinksdb", docid="asoda", attname="mtcarstable.csv")
#' doc_attach_delete(x, "drinksdb", docid="asoda", attname="img.png")
#' doc_attach_delete(x, "drinksdb", docid="asoda", attname="plot.pdf")
#' }

#' @export
#' @rdname attachments
doc_attach_create <- function(cushion, dbname, docid, attachment, attname,
                              as = "list", ...) {

  check_cushion(cushion)
  if (!file.exists(attachment)) stop("the file does not exist", call. = FALSE)
  revget <- db_revisions(cushion, dbname = dbname, docid = docid)[1]
  url <- file.path(cushion$make_url(), dbname, docid, attname)
  sofa_PUT_dac(url, as,
           body = crul::upload(attachment),
           rev = revget,
           headers = c(list(
            `Content-Type` = mime::guess_type(attachment)),
            cushion$get_headers()),
           auth = cushion$get_auth(), ...)
}

#' @export
#' @rdname attachments
doc_attach_info <- function(cushion, dbname, docid, attname, ...) {
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), dbname, docid, attname)
  sofa_HEAD(url, cushion$get_headers(), cushion$get_auth(), ...)
}

#' @export
#' @rdname attachments
doc_attach_get <- function(cushion, dbname, docid, attname, type = "raw", ...) {
  check_cushion(cushion)
  url <- file.path(cushion$make_url(), dbname, docid, attname)
  revget <- db_revisions(cushion, dbname = dbname, docid = docid)[1]
  type <- match.arg(type, c('text', 'raw'))
  cli <- crul::HttpClient$new(
    url = url,
    headers = sc(c(ct_json, cushion$get_headers(), list(`If-Match` = revget))),
    opts = sc(c(cushion$get_auth(), list(...))))
  res <- cli$get()
  stop_status(res)
  if (type == 'raw') res$content else res$parse("UTF-8")
}

#' @export
#' @rdname attachments
doc_attach_delete <- function(cushion, dbname, docid, attname, as = "list", ...) {
  check_cushion(cushion)
  revget <- db_revisions(cushion, dbname = dbname, docid = docid)[1]
  url <- file.path(cushion$make_url(), dbname, docid, attname)
  sofa_DELETE(url, as,
              sc(c(cushion$get_headers(),
                   list(Accept = "application/json", `If-Match` = revget))),
              cushion$get_auth(), ...)
}

sofa_PUT_dac <- function(url, as = 'list', body, rev,
                         encode = "json", headers = NULL, auth = NULL, ...){

  as <- match.arg(as, c('list','json'))
  cli <- crul::HttpClient$new(
    url = url,
    headers = sc(c(headers, list(`If-Match` = rev))),
    opts = sc(c(auth, list(...))))
  res <- cli$put(body = body, encode = encode)
  res$raise_for_status()
  tt <- res$parse('UTF-8')
  if (as == 'json') tt else jsonlite::fromJSON(tt, FALSE)
}

