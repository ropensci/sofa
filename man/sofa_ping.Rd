\name{sofa_ping}
\alias{sofa_ping}
\title{Ping the couchdb server.}
\usage{
  sofa_ping(endpoint = "http://127.0.0.1", port = 5984)
}
\arguments{
  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Ping the couchdb server.
}
\examples{
sofa_ping()
}

