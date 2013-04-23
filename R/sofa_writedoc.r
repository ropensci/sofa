#' Write documents to a database.
#' 
#' @inheritParams sofa_ping
#' @param dbname Database name3
#' @param doc Document content
#' @param docid Document ID
#' @param rodb Stand for "ropensci database". If TRUE, write with json format e.g.:
#'    {
#'      "baseurl" : "http://alm.plos.org/api/v3/articles",
#'      "yourqueryargs" : "doi=10.1371/journal.pone.0060590",
#'      "response": "response_from_the_api"
#'    }
#' @param baseurl Base url for the web API call
#' @param queryargs Web API query arguments to pass in to json with document
#' @examples
#' # write a document WITH a name (uses PUT)
#' doc1 <- '{"name":"dude","beer":"IPA"}'
#' sofa_writedoc(dbname="sofadb", doc=doc1, docid="dudesbeer")
#' 
#' # write a json document WITHOUT a name (uses POST)
#' doc2 <- '{"name":"dude","icecream":"rocky road"}'
#' sofa_writedoc(dbname="sofadb", doc=doc2)
#' 
#' # write an xml document WITH a name (uses PUT). xml is written as xml in 
#' # couchdb, just wrapped in json, when you get it out it will be as xml
#' doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' sofa_writedoc(dbname="sofadb", doc=doc3, docid="somexml")
#' 
#' # write a document using web api storage format
#' doc <- '{"downloads":10,"pageviews":5000,"tweets":300}'
#' sofa_writedoc(dbname="sofadb", doc=doc, rodb=TRUE, baseurl="http://shit", queryargs="some args")
#' @export
sofa_writedoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, doc, 
                          docid=NULL, rodb=FALSE, baseurl, queryargs)
{
  if(rodb){ # if true, 
    doc2 <- paste('{"baseurl":', '"', baseurl, '",', '"queryargs":', 
                  RJSONIO::toJSON(queryargs,collapse=""), ',', '"response":', doc, "}", sep="")
    if(!is.null(docid)){
      call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
      fromJSON(content(PUT(call_, body=doc2)))
    } else
    {
      call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, sep="")
      fromJSON(content(POST(call_, body=doc2, 
                            config=list(httpheader='Content-Type: application/json'))))
    }
  } else
  {
    # detect whether document is xml format or not, if true, wrap in json
    if(grepl("<[A-Za-z]+>", doc))
      doc2 <- paste('{"xml":', '"', doc, '"', '}', sep="")
    
    if(!is.null(docid)){
      call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
      fromJSON(content(PUT(call_, body=doc2)))
    } else
    {
      call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, sep="")
      fromJSON(content(POST(call_, body=doc2, 
                            config=list(httpheader='Content-Type: application/json'))))
    }
  }
}