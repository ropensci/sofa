\name{get_pwd}
\alias{get_pwd}
\title{Get auth info for a cushion}
\usage{
get_pwd(u = NULL, p = NULL, service)
}
\arguments{
  \item{u}{username}

  \item{p}{password}

  \item{service}{one of iriscouch, cloudant, etc.}
}
\description{
Get auth info for a cushion
}
\examples{
\dontrun{
get_pwd(service='cloudant')
}
}

