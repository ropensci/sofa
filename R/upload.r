#' Upload a local database to a remote database server, e.g., Cloudant, Iriscouch
#'
#' @inheritParams ping
#' @param to Remote service name to upload to. One of cloudant, iriscouch.
#' @param dbname Database name.
#' @param createdb If TRUE, the function creates the db on the remote server before
#'    uploading. The db has to exist before uploading, so either you do it separately
#'    or this fxn can do it for you. Default = FALSE
#' @export
#' @examples \donttest{
#' # Create a database locally
#' createdb('hello_earth')
#'
#' # Upload to a remote server
#' upload(to="cloudant", dbname="hello_earth", createdb=TRUE)
#' upload(to="iriscouch", dbname="hello_earth", createdb=TRUE)
#' }

upload <- function(to="cloudant", port=5984, dbname, username=NULL, pwd=NULL, createdb=FALSE)
{
  if(createdb)
    createdb(dbname, to)

  url <- sprintf('http://localhost:%s/_replicate', port)

  if(to=="cloudant"){
    message(sprintf("Uploading to %s...", to))
    auth <- get_pwd(username,pwd,"cloudant")
    args <- toJSON(list(source=dbname, target=sprintf("https://%s:%s@%s.cloudant.com/%s", auth[[1]], auth[[2]], auth[[1]], dbname)))
    fromJSON(content(POST(url, add_headers("Content-Type" = "application/json"), args)))
  } else
  {
    message(sprintf("Uploading to %s", to))
    auth <- get_pwd(username,pwd,"iriscouch")
    args <- toJSON(list(source=dbname, target=sprintf("https://%s.iriscouch.com/%s", auth[[1]], dbname)))
    fromJSON(content(POST(url, add_headers("Content-Type" = "application/json"), args)))
  }
}
