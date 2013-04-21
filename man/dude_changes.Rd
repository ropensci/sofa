\name{dude_changes}
\alias{dude_changes}
\title{List changes to a database.}
\usage{
  dude_changes(endpoint = "http://127.0.0.1", port = 5984,
    dbname, descending = NULL, startkey = NULL,
    endkey = NULL, limit = NULL, include_docs = NULL)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{descending}{Return in descending order? (logical)}

  \item{startkey}{Document ID to start at. (character)}

  \item{endkey}{Document ID to end at. (character)}

  \item{limit}{Number document IDs to return. (numeric)}

  \item{include_docs}{If TRUE, returns docs themselves, in
  addition to IDs (logical)}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  List changes to a database.
}
\examples{
dude_changes(dbname="dudedb")
dude_changes(dbname="dudedb", limit=2)
}

