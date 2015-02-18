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
#' @param apicall If TRUE, write with json format e.g.:
#'    {
#'      "baseurl" : "http://alm.plos.org/api/v3/articles",
#'      "yourqueryargs" : "doi=10.1371/journal.pone.0060590",
#'      "response": "response_from_the_api"
#'    }
#' @param baseurl Base url for the web API call
#' @param queryargs Web API query arguments to pass in to json with document
#' @details Documents can have attachments just like email. There are two ways to use attachments:
#' the first one is via a separate REST call (see \code{doc_attach}); the second is inline within
#' your document, you can do so with this fxn. See
#' \url{http://wiki.apache.org/couchdb/HTTP_Document_API#Attachments} for help on formatting
#' json appropriately.
#' @examples \donttest{
#' # write a document WITH a name (uses PUT)
#' doc1 <- '{"name":"drink","beer":"IPA"}'
#' doc_create(dbname="sofadb", doc=doc1, docid="abeer")
#' doc_create(dbname="sofadb", doc=doc1, docid="morebeer", as='json')
#' doc_get(dbname = "sofadb", docid = "abeer")
#'
#' # write a json document WITHOUT a name (uses POST)
#' doc2 <- '{"name":"food","icecream":"rocky road"}'
#' doc_create(dbname="sofadb", doc=doc2)
#'
#' doc3 <- '{"planet":"mars","size":"smallish"}'
#' doc_create(dbname="sofadb", doc=doc3)
#'
#' # write an xml document WITH a name (uses PUT). xml is written as xml in
#' # couchdb, just wrapped in json, when you get it out it will be as xml
#' doc4 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' doc_create(dbname="sofadb", doc=doc4, docid="somexml")
#' doc_get(dbname = "sofadb", docid = "somexml")
#'
#' # write a document using web api storage format
#' doc <- '{"downloads":10,"pageviews":5000,"tweets":300}'
#' doc_create(dbname="sofadb", doc=doc, docid="asdfg", apicall=TRUE, baseurl="http://things...",
#'    queryargs="some args")
#' doc_get(dbname = "sofadb", docid = "asdfg")
#'
#' # in iriscouch
#' doc_create("iriscouch", dbname='helloworld', doc='{"things":"stuff"}', docid="ggg")
#' doc_get("iriscouch", dbname='helloworld', docid="ggg")
#' doc_delete("iriscouch", dbname='helloworld', docid="ggg")
#'
#' # You can pass in lists that autoconvert to json internally
#' doc1 <- list(name = "drink", beer = "IPA")
#' doc_create(dbname="sofadb", doc=doc1, docid="goodbeer")
#'
#' # On arbitrary remote server
#' doc1 <- list(name = "drink", beer = "IPA")
#' doc_create("oceancouch", dbname="beard", doc=doc1, docid="goodbeer")
#' }

doc_create <- function(cushion="localhost", dbname, doc, docid=NULL, apicall=FALSE, baseurl,
  queryargs, as='list', ...)
{
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    call_ <- paste0(pick_url(cushion), dbname)
  } else {
    if(cushion$type=="localhost"){
      call_ <- sprintf("http://127.0.0.1:%s/%s", cushion$port, dbname)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      call_ <- remote_url(cushion, dbname)
    }
  }

  if(apicall){
    doc2 <- paste('{"baseurl":', '"', baseurl, '",', '"queryargs":',
                  toJSON(queryargs, collapse=""), ',', '"response":', doc, "}", sep="")
    if(!is.null(docid)){
      call_ <- paste0(call_, "/", docid)
      sofa_PUT(call_, as, body=doc2, ...)
    } else {
      sofa_POST(call_, as, body=doc2, ...)
    }
  } else {
    if(!is.null(docid)){
      sofa_PUT(paste0(call_, "/", docid), as, body=check_inputs(doc), ...)
    } else {
      sofa_POST(call_, as, body=check_inputs(doc), ...)
    }
  }
}
