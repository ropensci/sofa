\name{dude_getdoc}
\alias{dude_getdoc}
\title{Get a document from a database.}
\usage{
  dude_getdoc(endpoint = "http://127.0.0.1", port = 5984,
    dbname, docid)
}
\arguments{
  \item{dbname}{Database name}

  \item{docid}{Document ID}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Get a document from a database.
}
\examples{
dude_getdoc(dbname="twitter_db", docid="9f6950f1ee18ed0f0a2c529c30003ab0")
}

