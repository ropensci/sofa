\name{cushion}
\alias{cushion}
\title{Put a cushion on the sofa - i.e., set up config for remote CouchDB databases}
\usage{
  cushion(cloudant_name = NULL, cloudant_pwd = NULL,
    iriscouch_name = NULL, iriscouch_pwd = NULL)
}
\arguments{
  \item{cloudant_name}{Cloudant username}

  \item{cloudant_pwd}{Cloudant password}

  \item{iriscouch_name}{Iriscouch username}

  \item{iriscouch_pwd}{Iriscouch password}
}
\description{
  Put a cushion on the sofa - i.e., set up config for
  remote CouchDB databases
}
\examples{
\dontest{
cushion(cloudant_name='name', cloudant_pwd='pwd')
cushion(iriscouch_name='name', iriscouch_pwd='pwd')
}
}

