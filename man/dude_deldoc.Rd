\name{dude_deldoc}
\alias{dude_deldoc}
\title{List all docs in a given database.}
\usage{
  dude_deldoc(endpoint = "http://127.0.0.1", port = 5984,
    dbname, docid)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{docid}{Document ID (character)}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  List all docs in a given database.
}
\examples{
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
dude_writedoc(dbname="dudedb", doc=doc3, docid="somexml")
dude_deldoc(dbname="dudedb", docid="somexml")

# wrong docid name
dude_writedoc(dbname="dudedb", doc=doc3, docid="somexml")
dude_deldoc(dbname="dudedb", docid="wrongname")
}

