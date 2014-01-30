\name{cushion}
\alias{cushion}
\title{Put a cushion on the sofa - i.e., set up config for remote CouchDB databases}
\usage{
cushion(...)
}
\arguments{
  \item{...}{Enter named sets of username and password.}
}
\description{
Put a cushion on the sofa - i.e., set up config for remote
CouchDB databases
}
\details{
Setup for authentication: For localhost you don't need to
authenticate, but of course you may have set up a username
and password in which case use 'localhost'.

Others supported are 'cloudant' and 'iriscouch'.

You can use other named username/password sets too.

You can permanently store your auth details in your
.Rprofile by putting in entries like this:

options(sofa_cloudant = c("username","yourcoolpassword"))

Though if you don't want to store them permanently, you can
use the cushion() function instead. See examples below on
how to do this. Though using cusion() only stores them for
the current session.
}
\examples{
\dontest{
cushion(sofa_cloudant=c('name','pwd'), sofa_iriscouch=c('name','pwd'))
}
}

