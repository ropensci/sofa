\name{dude_getattach}
\alias{dude_getattach}
\title{Get an attachment.}
\usage{
  dude_getattach(endpoint = "http://127.0.0.1",
    port = 5984, dbname, docid, attname = NULL)
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
dude_getattach(dbname="dudedb", docid="guysbeer")
}

