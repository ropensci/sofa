\name{dude_search}
\alias{dude_search}
\title{Full text search of any CouchDB databases using Elasticsearch.}
\usage{
  dude_search(endpoint = "http://127.0.0.1", port = 9200,
    dbname, parse_ = TRUE, verbose = TRUE, ...)
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
results <- dude_search(dbname="rplos_db", q="scienceseeker")
sapply(results, function(x) x$id) # get the document IDs
sapply(results, function(x) x$res) # get the document contents
sapply(results, function(x) x$res)[[1]][[1]] # get one of the documents contents'
}

