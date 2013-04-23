\name{sofa_listdbs}
\alias{sofa_listdbs}
\title{List all databases.}
\usage{
  sofa_listdbs(endpoint = "http://127.0.0.1", port = 5984)
}
\arguments{
  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  List all databases.
}
\examples{
sofa_listdbs()
}

