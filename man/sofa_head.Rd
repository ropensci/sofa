\name{sofa_head}
\alias{sofa_head}
\title{Just get header info on a document}
\usage{
  sofa_head(endpoint = "localhost", port = 5984, dbname,
    docid, username = NULL, pwd = NULL)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{docid}{Document ID (character)}

  \item{username}{Your cloudant or iriscouch username}

  \item{pwd}{Your cloudant or iriscouch password}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Just get header info on a document
}
\examples{
sofa_head(dbname="foobar", docid="dudesbeer")
}

