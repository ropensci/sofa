% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/db_delete.r
\name{db_delete}
\alias{db_delete}
\title{Delete a database.}
\usage{
db_delete(cushion, dbname, as = "list", ...)
}
\arguments{
\item{cushion}{A \code{\link{Cushion}} object. Required.}

\item{dbname}{Database name}

\item{as}{(character) One of list (default) or json}

\item{...}{Curl args passed on to \code{\link[crul]{HttpClient}}}
}
\value{
JSON as a character string or a list (determined by the
\code{as} parameter)
}
\description{
Delete a database.
}
\examples{
\dontrun{
user <- Sys.getenv("COUCHDB_TEST_USER")
pwd <- Sys.getenv("COUCHDB_TEST_PWD")
(x <- Cushion$new(user = user, pwd = pwd))

# local databasees
## create database first, then delete
db_create(x, dbname = "newdb")
db_delete(x, dbname = "newdb")

## with curl info while doing request
library("crul")
db_create(x, "newdb")
db_delete(x, "newdb", verbose = TRUE)
}
}
