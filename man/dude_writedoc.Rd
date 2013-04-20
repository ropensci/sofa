\name{dude_writedoc}
\alias{dude_writedoc}
\title{Write documents to a database.}
\usage{
  dude_writedoc(endpoint = "http://127.0.0.1", port = 5984,
    dbname, doc, docid = NULL)
}
\arguments{
  \item{dbname}{Database name3}

  \item{doc}{Document content}

  \item{docid}{Document ID}

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
dude_writedoc(dbname="dudedb", doc=doc1, docid="dudesbeer")

# write a json document WITHOUT a name (uses POST)
doc2 <- '{"name":"dude","icecream":"rocky road"}'
dude_writedoc(dbname="dudedb", doc=doc2)

# write an xml document WITH a name (uses PUT). xml is written as xml in
# couchdb, just wrapped in json, when you get it out it will be as xml
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
dude_writedoc(dbname="dudedb", doc=doc3, docid="somexml")
}

