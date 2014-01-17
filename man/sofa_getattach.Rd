\name{sofa_getattach}
\alias{sofa_getattach}
\title{Get an attachment.}
\usage{
sofa_getattach(endpoint = "http://127.0.0.1", port = 5984, dbname, docid,
  attname = NULL)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{docid}{Document ID (character)}

  \item{attname}{Attachment name.}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
Get an attachment.
}
\examples{
sofa_getattach(dbname="sofadb", docid="guysbeer")
}

