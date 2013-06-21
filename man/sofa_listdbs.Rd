\name{sofa_listdbs}
\alias{sofa_listdbs}
\title{List all databases.}
\usage{
  sofa_listdbs(endpoint = "localhost", port = 5984,
    username = NULL, pwd = NULL)
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
  List all databases.
}
\examples{
\donttest{
# local databasees
sofa_listdbs()

# databasees on cloudant
## passing username and password in function call
sofa_listdbs("cloudant", username='yourusername', pwd='yourpassword')

## or setting username and password in options() call
cushion(cloudant_username='name', cloudant_pwd='pwd')
sofa_listdbs("cloudant")
}
}

