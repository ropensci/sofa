\name{sofa_createdb}
\alias{sofa_createdb}
\title{Create a database.}
\usage{
sofa_createdb(dbname, endpoint = "localhost", port = 5984,
  username = NULL, pwd = NULL, delifexists = FALSE)
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

  \item{delifexists}{If TRUE, delete any database of the
  same name before creating it.  This is useful for
  testing. Default is FALSE.}
}
\description{
Create a database.
}
\examples{
\donttest{
sofa_createdb(dbname='sofadb')
sofa_listdbs() # see if its there now

## or setting username and password in cushion() call
cushion(cloudant_name='name', cloudant_pwd='pwd')
sofa_createdb(dbname="mustache", "cloudant")

## iriscouch
cushion(iriscouch_name='name', iriscouch_pwd='pwd')
sofa_createdb(dbname="mustache", "iriscouch")

# different login credentials than normal, just pass in to function call
sofa_createdb(dbname='shit', "cloudant", username='app16517180.heroku', pwd='DA1w5hbKJJAtcGnF74Ds3nVl')
}
}

