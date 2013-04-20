\name{dude_deldoc}
\alias{dude_deldoc}
\title{List all docs in a given database.}
\usage{
  dude_deldoc(endpoint = "http://127.0.0.1", port = 5984,
    dbname, docid)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{asdf}{Return as data.frame? defaults to TRUE
  (logical)}

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
  List all docs in a given database.
}
\examples{
dude_createdoc()
dude_deldoc(dbname="twitter_db", docid="9f6950f1ee18ed0f0a2c529c30003ab0")
}

