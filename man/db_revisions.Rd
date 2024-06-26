% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/revisions.r
\name{db_revisions}
\alias{db_revisions}
\title{Get document revisions.}
\usage{
db_revisions(cushion, dbname, docid, simplify = TRUE, as = "list", ...)
}
\arguments{
\item{cushion}{A \code{\link{Cushion}} object. Required.}

\item{dbname}{Database name}

\item{docid}{Document ID}

\item{simplify}{(logical) Simplify to character vector of revision ids.
If \code{FALSE}, gives back availability info too. Default: \code{TRUE}}

\item{as}{(character) One of list (default) or json}

\item{...}{Curl args passed on to \code{\link[crul]{HttpClient}}}
}
\value{
JSON as a character string or a list (determined by the
\code{as} parameter)
}
\description{
Get document revisions.
}
\examples{
\dontrun{
user <- Sys.getenv("COUCHDB_TEST_USER")
pwd <- Sys.getenv("COUCHDB_TEST_PWD")
(x <- Cushion$new(user = user, pwd = pwd))

if ("sofadb" \%in\% db_list(x)) {
  db_delete(x, dbname = "sofadb")
}
db_create(x, dbname = "sofadb")

doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
doc_create(x, dbname = "sofadb", doc1, docid = "abeer")
doc_create(x, dbname = "sofadb", doc1, docid = "morebeer", as = "json")

db_revisions(x, dbname = "sofadb", docid = "abeer")
db_revisions(x, dbname = "sofadb", docid = "abeer", simplify = FALSE)
db_revisions(x, dbname = "sofadb", docid = "abeer", as = "json")
db_revisions(x, dbname = "sofadb", docid = "abeer", simplify = FALSE, as = "json")
}
}
