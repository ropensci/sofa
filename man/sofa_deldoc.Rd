\name{sofa_deldoc}
\alias{sofa_deldoc}
\title{Delete a document in a database.}
\usage{
sofa_deldoc(endpoint = "http://127.0.0.1", port = 5984, dbname, docid)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{docid}{Document ID (character)}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
Delete a document in a database.
}
\examples{
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
sofa_writedoc(dbname="sofadb", doc=doc3, docid="somexml")
sofa_deldoc(dbname="sofadb", docid="somexml")

# wrong docid name
sofa_writedoc(dbname="sofadb", doc=doc3, docid="somexml")
sofa_deldoc(dbname="sofadb", docid="wrongname")
}

