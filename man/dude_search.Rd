\name{dude_search}
\alias{dude_search}
\title{Full text search of any CouchDB databases using Elasticsearch.}
\usage{
  dude_search(endpoint = "http://127.0.0.1", port = 9200,
    dbname, q)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{docid}{Document ID (character)}

  \item{q}{Query terms.}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Full text search of any CouchDB databases using
  Elasticsearch.
}
\details{
  There are a lot of terms you can use for Elasticsearch.
  See here
  \url{http://www.elasticsearch.org/guide/reference/query-dsl/}
  for the documentation.
}
\examples{
dude_search(dbname="dudedb", q="road")
}

