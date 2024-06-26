% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/restart.R
\name{restart}
\alias{restart}
\title{Restart your Couchdb instance}
\usage{
restart(cushion = "localhost", as = "list", ...)
}
\arguments{
\item{cushion}{A \code{\link{Cushion}} object. Required.}

\item{as}{(character) One of list (default) or json}

\item{...}{Curl args passed on to \code{\link[crul]{HttpClient}}}
}
\value{
JSON as a character string or a list (determined by the
\code{as} parameter)
}
\description{
Restart your Couchdb instance
}
\examples{
\dontrun{
user <- Sys.getenv("COUCHDB_TEST_USER")
pwd <- Sys.getenv("COUCHDB_TEST_PWD")
(x <- Cushion$new(user = user, pwd = pwd))

# restart(x)
}
}
