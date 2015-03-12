#' Create documents to a database.
#'
#' @export
#' @inheritParams ping
#' @param cushion A cushion name
#' @param dbname Database name3
#' @param doc Document content, can be character string, a list. The character type can be
#' XML as well, which is embedded in json. When the document is retrieved via
#' \code{\link{doc_get}}, the XML is given back and you can parse it as normal.
#' @param docid Document ID
#'
#' @details Documents can have attachments just like email. There are two ways to use attachments:
#' the first one is via a separate REST call (see \code{\link{attach_create}}); the second is
#' inline within your document, you can do so with this fxn. See
#' \url{http://wiki.apache.org/couchdb/HTTP_Document_API#Attachments} for help on formatting
#' json appropriately.
#' @examples \donttest{
#' # write a document WITH a name (uses PUT)
#' doc1 <- '{"name":"drink","beer":"IPA"}'
#' doc_create(doc1, dbname="sofadb", docid="abeer")
#' doc_create(doc1, dbname="sofadb", docid="morebeer", as='json')
#' doc_get(dbname = "sofadb", docid = "abeer")
#'
#' # write a json document WITHOUT a name (uses POST)
#' doc2 <- '{"name":"food","icecream":"rocky road"}'
#' doc_create(doc2, dbname="sofadb")
#'
#' doc3 <- '{"planet":"mars","size":"smallish"}'
#' doc_create(doc3, dbname="sofadb")
#'
#' # write an xml document WITH a name (uses PUT). xml is written as xml in
#' # couchdb, just wrapped in json, when you get it out it will be as xml
#' doc4 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' doc_create(doc4, dbname="sofadb", docid="somexml")
#' doc_get(dbname = "sofadb", docid = "somexml")
#'
#' # in iriscouch
#' doc_create('{"things":"stuff"}', cushion="iriscouch", dbname='helloworld', docid="ggg")
#' doc_get("iriscouch", dbname='helloworld', docid="ggg")
#' doc_delete("iriscouch", dbname='helloworld', docid="ggg")
#'
#' # You can pass in lists that autoconvert to json internally
#' doc1 <- list(name = "drink", beer = "IPA")
#' doc_create(doc1, dbname="sofadb", docid="goodbeer")
#'
#' # On arbitrary remote server
#' doc1 <- list(name = "drink", beer = "IPA")
#' doc_create(doc1, cushion="oceancouch", dbname="beard", docid="goodbeer")
#'
#' # Write directly from a data.frame
#' ## Each row or column becomes a separate document
#' ### by rows
#' doc_create(dat, dbname="test", how="rows")
#' doc_create(dat, dbname="test", how="columns")
#'
#' head(iris)
#' db_create(dbname = "iris")
#' doc_create(iris, dbname = "iris")
#' }
doc_create <- function(doc, cushion = "localhost", dbname, docid = NULL,
                       how = 'rows', as = 'list', ...) {
  UseMethod("doc_create")
}

#' @export
doc_create.character <- function(doc, cushion = "localhost", dbname, docid = NULL,
                                 how = 'rows', as = 'list', ...) {
  url <- cush(cushion, dbname)
  if(!is.null(docid)){
    sofa_PUT(paste0(url, "/", docid), as, body=check_inputs(doc), ...)
  } else {
    sofa_POST(url, as, body=check_inputs(doc), ...)
  }
}

#' @export
doc_create.list <- function(doc, cushion = "localhost", dbname, docid = NULL,
                                 how = 'rows', as = 'list', ...) {
  url <- cush(cushion, dbname)
  if(!is.null(docid)){
    sofa_PUT(paste0(url, "/", docid), as, body=check_inputs(doc), ...)
  } else {
    sofa_POST(url, as, body=check_inputs(doc), ...)
  }
}

#' @export
doc_create.data.frame <- function(doc, cushion = "localhost", dbname, docid = NULL,
                            how = 'rows', as = 'list', ...) {
  url <- cush(cushion, dbname)
  each <- parse_df(doc, how = how)
  lapply(each, function(x) sofa_POST(url, as, body = x, ...))
}

cush <- function(cushion, dbname) {
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    paste0(pick_url(cushion), dbname)
  } else {
    if(cushion$type=="localhost"){
      sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      remote_url(cushion, dbname)
    }
  }
}

# parse each row, column, or all to json to become documents
#
# row.names(mtcars) <- NULL
# parse_df(mtcars, "rows")
# parse_df(mtcars, "columns")
# parse_df(mtcars, "one")
# doc_create("localhost", dbname="test", doc = dat)
# doc_create("localhost", dbname="test", doc = parse_df(mtcars, "rows")[1])
parse_df <- function(dat, how = "rows", tojson = TRUE, ...) {
  how <- match.arg(how, c('rows','columns'))
  switch(how,
         rows = {
           apply(dat, 1, function(x){
             if(tojson){
               toJSON(as.list(setNames(x, names(dat))), auto_unbox = TRUE, ...)
             } else {
               as.list(setNames(x, names(dat)))
             }
           })
         },
         columns = {
           out <- list()
           for(i in seq_along(dat)){
             out[[ names(dat)[i] ]] <- setNames(list(dat[,i]), names(dat)[i])
           }
           if(tojson){
             lapply(out, toJSON, auto_unbox = TRUE, ...)
           } else {
             out
           }
         }
  )
}

# tojsonnamed <- function(x) {
#
#   jsonlite::toJSON(x, auto_unbox = TRUE)
# }
