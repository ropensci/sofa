\name{dude_createdb}
\alias{dude_createdb}
\title{Create a database.}
\usage{
  dude_createdb(endpoint = "http://127.0.0.1", port = 5984,
    dbname)
}
\arguments{
  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Create a database.
}
\examples{
dude_createdb(dbname='dudedb')
dude_listdbs() # see if its there now
}

