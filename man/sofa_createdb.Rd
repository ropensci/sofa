\name{sofa_createdb}
\alias{sofa_createdb}
\title{Create a database.}
\usage{
  sofa_createdb(endpoint = "http://127.0.0.1", port = 5984,
    dbname)
}
\arguments{
  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Create a database.
}
\examples{
sofa_createdb(dbname='sofadb')
sofa_listdbs() # see if its there now
}

