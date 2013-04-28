\name{rawdata}
\alias{rawdata}
\title{Prints the raw results of the call.}
\usage{
  rawdata(x, ...)
}
\arguments{
  \item{x}{input}

  \item{...}{more stuff}
}
\description{
  Prints the raw results of the call.
}
\examples{
results <- elasticsearch(dbname="rplos_db", q="scienceseeker")
rawdata(results)
}

