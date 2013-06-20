\name{sofa_createdb}
\alias{sofa_createdb}
\title{Create a database.}
\usage{
  sofa_createdb(dbname, endpoint = "http://127.0.0.1",
    port = 5984, username = NULL, pwd = NULL)
}
\arguments{
  \item{endpoint}{One of localhost, cloudant, or iriscouch.
  For local work use the default localhost. For cloudant or
  iriscouch you will need accounts with those database
  services.}

  \item{port}{The port to use. Only applicable if using
  endpoint="localhost".}

  \item{username}{Your cloudant or iriscouch username}

  \item{pwd}{Your cloudant or iriscouch password}
}
\description{
  Create a database.
}
\examples{
\dontest{
sofa_createdb(dbname='sofadb')
sofa_listdbs() # see if its there now

## or setting username and password in options() call
options(cloudant.username="yourusername")
options(cloudant.pwd="yourpassword")
sofa_createdb(dbname="mustache", "cloudant")
}
}

