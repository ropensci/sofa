\name{sofa_profile}
\alias{sofa_profile}
\title{Get auth information}
\usage{
  sofa_profile()
}
\description{
  Get auth information
}
\details{
  Looks first in the local environment SofaAuthCache, and
  if finds nothing, looks in your .Rprofile file.
}
\examples{
\dontest{
sofa_profile()
}
}

