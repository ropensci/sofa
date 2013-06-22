\name{sofa_changes}
\alias{sofa_changes}
\title{List changes to a database.}
\usage{
  sofa_changes(endpoint = "localhost", port = 5984, dbname,
    descending = NULL, startkey = NULL, endkey = NULL,
    since = NULL, limit = NULL, include_docs = NULL,
    feed = "normal", heartbeat = NULL, filter = NULL,
    username = NULL, pwd = NULL)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{descending}{Return in descending order? (logical)}

  \item{startkey}{Document ID to start at. (character)}

  \item{endkey}{Document ID to end at. (character)}

  \item{since}{Start the results from the change
  immediately after the given sequence number.}

  \item{limit}{Number document IDs to return. (numeric)}

  \item{include_docs}{If "true", returns docs themselves,
  in addition to IDs (character)}

  \item{feed}{Select the type of feed. One of normal,
  longpoll, or continuous. See description. (character)}

  \item{heartbeat}{Period in milliseconds after which an
  empty line is sent in the results.  Only applicable for
  longpoll or continuous feeds. Overrides any timeout to
  keep the feed alive indefinitely. (numeric
  (milliseconds))}

  \item{filter}{Reference a filter function from a design
  document to selectively get updates.}

  \item{username}{User name}

  \item{pwd}{Password}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Of course it doesn't make much sense to use certain
  options in _changes. For example, using feed=longpoll or
  continuous doesn't make much sense within R itself.
}
\examples{
sofa_changes(dbname="sofadb")
sofa_changes(dbname="sofadb", limit=2)
}

