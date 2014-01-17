\name{sofa_upload}
\alias{sofa_upload}
\title{Upload a local database to a remote database server, e.g., Cloudant, Iriscouch}
\usage{
sofa_upload(to = "cloudant", port = 5984, dbname, username = NULL,
  pwd = NULL, createdb = FALSE)
}
\arguments{
  \item{to}{Remote service name to upload to. One of
  cloudant, iriscouch.}

  \item{dbname}{Database name.}

  \item{createdb}{If TRUE, the function creates the db on
  the remote server before uploading. The db has to exist
  before uploading, so either you do it separately or this
  fxn can do it for you. Default = FALSE}

  \item{port}{port to connect to, defaults to 5984}

  \item{username}{Your cloudant or iriscouch username}

  \item{pwd}{Your cloudant or iriscouch password}
}
\description{
Upload a local database to a remote database server, e.g.,
Cloudant, Iriscouch
}
\examples{
\donttest{
# Create a database locally
sofa_createdb('hello_earth')

# Upload to a remote server
sofa_upload(to="cloudant", dbname="hello_earth", createdb=TRUE)
sofa_upload(to="iriscouch", dbname="hello_earth", createdb=TRUE)
}
}

