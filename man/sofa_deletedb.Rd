\name{sofa_deletedb}
\alias{sofa_deletedb}
\title{Delete a database.}
\usage{
  sofa_deletedb(dbname, endpoint = "localhost",
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
  Delete a database.
}
\examples{
\donttest{
# local databasees
sofa_deletedb(dbname="shitbutt")

## or setting username and password in options() call
options(cloudant.username="yourusername")
options(cloudant.pwd="yourpassword")
sofa_deletedb(dbname="foobardb", "cloudant")
}
}

