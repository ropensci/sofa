% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/db_replicate.r
\name{db_replicate}
\alias{db_replicate}
\title{Upload (replicate) a local database to a remote database server,
e.g., Cloudant, Iriscouch}
\usage{
db_replicate(from, to, dbname, createdb = FALSE, as = "list", ...)
}
\arguments{
\item{from}{Couch to replicate from. An object of class \link{Cushion}.
Required.}

\item{to}{Remote couch to replicate to. An object of class \link{Cushion}.
Required.}

\item{dbname}{(character) Database name. Required.}

\item{createdb}{If \code{TRUE}, the function creates the db on the remote
server before uploading. The db has to exist before uploading, so either
you do it separately or this fxn can do it for you. Default: \code{FALSE}}

\item{as}{(character) One of list (default) or json}

\item{...}{Curl args passed on to \link[crul:HttpClient]{crul::HttpClient}}
}
\value{
JSON as a character string or a list (determined by the
\code{as} parameter)
}
\description{
Upload (replicate) a local database to a remote database server,
e.g., Cloudant, Iriscouch
}
\examples{
\dontrun{
if (interactive()) {
  ## create a connection
  user <- Sys.getenv("COUCHDB_TEST_USER")
  pwd <- Sys.getenv("COUCHDB_TEST_PWD")
  (x <- Cushion$new(user = user, pwd = pwd))

  # Create a database locally
  db_list(x)
  if ("hello_earth" \%in\% db_list(x)) {
    invisible(db_delete(x, dbname = "hello_earth"))
  }
  db_create(x, "hello_earth")

  ## replicate to a remote server
  z <- Cushion$new(
    host = "ropensci.cloudant.com", transport = "https",
    port = NULL, user = "ropensci", pwd = Sys.getenv("CLOUDANT_PWD")
  )

  ## do the replication
  db_replicate(x, z, dbname = "hello_earth")

  ## check changes on the remote
  db_list(z)
  db_changes(z, dbname = "hello_earth")

  ## make some changes on the remote
  doc_create(z,
    dbname = "hello_earth",
    '{"language":"python","library":"requests"}', "stuff"
  )
  changes(z, dbname = "hello_earth")

  ## create another document, and try to get it
  doc_create(z,
    dbname = "hello_earth", doc = '{"language":"R"}',
    docid = "R_rules"
  )
  doc_get(z, dbname = "hello_earth", docid = "R_rules")

  ## cleanup - delete the database
  db_delete(z, "hello_earth")
}
}
}
