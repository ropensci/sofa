\name{sofa_view_search}
\alias{sofa_view_search}
\title{Search your CouchDB database using a view.}
\usage{
sofa_view_search(dbname, design_name, query = NULL,
  endpoint = "http://127.0.0.1", port = 5984)
}
\arguments{
  \item{dbname}{Database name}

  \item{design_name}{Design document name}

  \item{query}{Query terms}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
Search your CouchDB database using a view.
}
\examples{
\dontrun{
sofa_view_search(dbname='alm_couchdb', design_name='almview1', query="XXX")
}
}

