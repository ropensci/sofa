#' Ping the couchdb server.
#' 
#' @param endpoint the endpoint, defaults to localhost (http://127.0.0.1)
#' @param port port to connect to, defaults to 5984
#' @examples
#' dude_ping()
#' @export
dude_ping <- function(endpoint="http://127.0.0.1", port=5984)
{
  fromJSON(content(GET(paste(endpoint, port, sep=":"))))
}

#' List all databases.
#' 
#' @inheritParams dude_ping
#' @examples
#' dude_listdbs()
#' @export
dude_listdbs <- function(endpoint="http://127.0.0.1", port=5984)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/_all_dbs", sep="")
  fromJSON(content(GET(call_)))
}

#' Create a database.
#' 
#' @inheritParams dude_ping
#' @examples
#' dude_createdb(dbname='dudedb')
#' dude_listdbs() # see if its there now
#' @export
dude_createdb <- function(endpoint="http://127.0.0.1", port=5984, dbname)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, sep="")
  fromJSON(content(PUT(call_)))
}

#' Write documents to a database.
#' 
#' @inheritParams dude_ping
#' @param dbname Database name3
#' @param doc Document content
#' @param docid Document ID
#' @examples
#' # write a document WITH a name (uses PUT)
#' doc1 <- '{"name":"dude","beer":"IPA"}'
#' dude_writedoc(dbname="dudedb", doc=doc1, docid="dudesbeer")
#' 
#' # write a json document WITHOUT a name (uses POST)
#' doc2 <- '{"name":"dude","icecream":"rocky road"}'
#' dude_writedoc(dbname="dudedb", doc=doc2)
#' 
#' # write an xml document WITH a name (uses PUT). xml is written as xml in 
#' # couchdb, just wrapped in json, when you get it out it will be as xml
#' doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
#' dude_writedoc(dbname="dudedb", doc=doc3, docid="somexml")
#' @export
dude_writedoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, doc, 
                          docid=NULL)
{
  if(grepl("<[A-Za-z]+>", doc))
    doc <- paste('{"xml":', '"', doc, '"', '}', sep="")
  if(!is.null(docid)){
    call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
    fromJSON(content(PUT(call_, body=doc)))
  } else
  {
    call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, sep="")
    fromJSON(content(POST(call_, body=doc, 
                          config=list(httpheader='Content-Type: application/json'))))
  }
}

#' Get a document from a database.
#' 
#' @inheritParams dude_ping
#' @param dbname Database name
#' @param docid Document ID
#' @examples
#' dude_getdoc(dbname="twitter_db", docid="9f6950f1ee18ed0f0a2c529c30003ab0")
#' @export
dude_getdoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
  fromJSON(content(GET(call_)))
}

#' List all docs in a given database.
#'
#' @inheritParams dude_ping
#' @param dbname Database name. (charcter)
#' @param asdf Return as data.frame? defaults to TRUE (logical)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @examples
#' dude_alldocs(dbname="twitter_db")
#' dude_alldocs(dbname="twitter_db", limit=2)
#' dude_alldocs(dbname="twitter_db", limit=2, include_docs="true")
#' @export
dude_alldocs <- function(endpoint="http://127.0.0.1", port=5984, dbname, asdf = TRUE,
                         descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, 
                         include_docs=NULL)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/_all_docs", sep="")
  args <- compact(list(descending=descending, startkey=startkey,endkey=endkey,
                       limit=limit,include_docs=include_docs))
  temp <- fromJSON(content(GET(call_, query=args)))
  if(asdf & is.null(include_docs)){
    return( ldply(temp$rows, function(x) as.data.frame(x)) )
  } else
  { temp }
}


#' List all docs in a given database.
#'
#' @inheritParams dude_ping
#' @param dbname Database name. (charcter)
#' @param asdf Return as data.frame? defaults to TRUE (logical)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @examples
#' dude_createdoc()
#' dude_deldoc(dbname="twitter_db", docid="9f6950f1ee18ed0f0a2c529c30003ab0")
#' @export
dude_deldoc <- function(endpoint="http://127.0.0.1", port=5984, dbname, docid)
{
  call_ <- paste(paste(endpoint, port, sep=":"), "/", dbname, "/", docid, sep="")
  fromJSON(content(DELETE(call_)))
}