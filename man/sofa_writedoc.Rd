\name{sofa_writedoc}
\alias{sofa_writedoc}
\title{Write documents to a database.}
\usage{
  sofa_writedoc(endpoint = "http://127.0.0.1", port = 5984,
    dbname, doc, docid = NULL, rodb = FALSE, baseurl,
    queryargs)
}
\arguments{
  \item{dbname}{Database name3}

  \item{doc}{Document content}

  \item{docid}{Document ID}

  \item{rodb}{Stand for "ropensci database". If TRUE, write
  with json format e.g.: { "baseurl" :
  "http://alm.plos.org/api/v3/articles", "yourqueryargs" :
  "doi=10.1371/journal.pone.0060590", "response":
  "response_from_the_api" }}

  \item{baseurl}{Base url for the web API call}

  \item{queryargs}{Web API query arguments to pass in to
  json with document}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Write documents to a database.
}
\examples{
# write a document WITH a name (uses PUT)
doc1 <- '{"name":"dude","beer":"IPA"}'
sofa_writedoc(dbname="sofadb", doc=doc1, docid="dudesbeer")

# write a json document WITHOUT a name (uses POST)
doc2 <- '{"name":"dude","icecream":"rocky road"}'
sofa_writedoc(dbname="sofadb", doc=doc2)

# write an xml document WITH a name (uses PUT). xml is written as xml in
# couchdb, just wrapped in json, when you get it out it will be as xml
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
sofa_writedoc(dbname="sofadb", doc=doc3, docid="somexml")

# write a document using web api storage format
doc <- '{"downloads":10,"pageviews":5000,"tweets":300}'
sofa_writedoc(dbname="sofadb", doc=doc, rodb=TRUE, baseurl="http://shit", queryargs="some args")
}

