#' Delete a document in a database.
#'
#' @export
#' @inheritParams ping
#' @param dbname Database name. (charcter)
#' @param docid Document ID (character)
#' @examples \donttest{
#' doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' doc_create(dbname="sofadb", doc=doc3, docid="newnewxml")
#' doc_delete(dbname="sofadb", docid="newnewxml")
#' doc_delete(dbname="sofadb", docid="newnewxml")
#'
#' # wrong docid name
#' doc_create(dbname="sofadb", doc=doc3, docid="newxml")
#' doc_delete(dbname="sofadb", docid="wrongname")
#'
#' # remote
#' doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' doc_create("cloudant", dbname="mustache", doc=doc3, docid="bbbb")
#' doc_get("cloudant", dbname='mustache', docid='bbbb')
#' doc_delete("cloudant", dbname='mustache', docid='bbbb')
#'
#' # On arbitrary remote server
#' doc <- list(name = "drink", beer = "IPA")
#' doc_create("oceancouch", dbname="beard", doc=doc, docid="beer")
#' doc_delete("oceancouch", dbname="beard", docid="beer")
#' }

doc_delete <- function(cushion="localhost", dbname, docid, as='list', ...)
{
  revget <- doc_get(cushion, dbname, docid)[["_rev"]]
  cushion <- get_cushion(cushion)
  if(is.null(cushion$type)){
    url <- pick_url(cushion)
    sofa_DELETE(sprintf("%s%s/%s", url, dbname, docid), as, query=list(rev=revget), ...)
  } else {
    if(cushion$type=="localhost"){
      sofa_DELETE(sprintf("http://127.0.0.1:%s/%s/%s", cushion$port, dbname, docid), as, query=list(rev=revget), ...)
    } else if(cushion$type %in% c("cloudant",'iriscouch')){
      sofa_DELETE(file.path(remote_url(cushion, dbname), docid), as, query=list(rev=revget), ...)
    }
  }
}
