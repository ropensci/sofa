\name{dude_attach}
\alias{dude_attach}
\title{Include an attachment either on an existing or new document.}
\usage{
  dude_attach(endpoint = "http://127.0.0.1", port = 5984,
    dbname, docid, attachment, attname)
}
\arguments{
  \item{dbname}{Database name. (charcter)}

  \item{docid}{Document ID (character)}

  \item{attachment}{The attachment object name}

  \item{attname}{Attachment name.}

  \item{endpoint}{the endpoint, defaults to localhost
  (http://127.0.0.1)}

  \item{port}{port to connect to, defaults to 5984}
}
\description{
  Include an attachment either on an existing or new
  document.
}
\examples{
# put on to an existing document
doc <- '{"name":"guy","beer":"anybeerisfine"}'
dude_writedoc(dbname="dudedb", doc=doc, docid="guysbeer")
myattachment <- "just a simple text string"
myattachment <- mtcars
dude_attach(dbname="dudedb", docid="guysbeer", attachment=myattachment, attname="mtcarstable.csv")
}

