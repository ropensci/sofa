\name{sofa_view_del}
\alias{sofa_view_del}
\title{Delete a design document from your CouchDB database.}
\usage{
sofa_view_del(dbname, design_name, endpoint = "http://127.0.0.1",
  port = 5984)
}
\arguments{
  \item{dbname}{Database name}

  \item{design_name}{Design document name}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
Delete a design document from your CouchDB database.
}
\examples{
\dontrun{
sofa_view_del(dbname='alm_couchdb', design_name='almview1')
}
}

