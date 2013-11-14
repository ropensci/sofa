\name{sofa_alldocs}
\alias{sofa_alldocs}
\title{List all docs in a given database.}
\usage{
  sofa_alldocs(cushion = "localhost", port = 5984, dbname,
    asdf = TRUE, descending = NULL, startkey = NULL,
    endkey = NULL, limit = NULL, include_docs = NULL,
    username = NULL, pwd = NULL)
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

  \item{port}{port to connect to, defaults to 5984}

  \item{username}{Your cloudant or iriscouch username}

  \item{pwd}{Your cloudant or iriscouch password}
}
\description{
  List all docs in a given database.
}
\examples{
sofa_alldocs(dbname="sofadb")
sofa_alldocs(dbname="twitter_db", limit=2)
sofa_alldocs(dbname="twitter_db", limit=2, include_docs="true")

# different login credentials than normal, just pass in to function call
sofa_alldocs(cushion="sofa_cloudant", dbname='dbname', username='username', pwd='password')

# different login credentials than normal, just pass in to function call
sofa_alldocs(cushion="sofa_cloudant_heroku", dbname='gaugesdb_ro', include_docs='true')
}

