#' Create a database.
#' 
#' @import httr rjson
#' @param endpoint One of localhost, cloudant, or iriscouch. For local work 
#'    use the default localhost. For cloudant or iriscouch you will need accounts 
#'    with those database services.
#' @param port The port to use. Only applicable if using endpoint="localhost".
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @examples \donttest{
#' sofa_createdb(dbname='sofadb')
#' sofa_listdbs() # see if its there now
#' 
#' ## or setting username and password in cushion() call
#' cushion(cloudant_name='name', cloudant_pwd='pwd')
#' sofa_createdb(dbname="mustache", "cloudant")
#' 
#' ## iriscouch
#' cushion(iriscouch_name='name', iriscouch_pwd='pwd')
#' sofa_createdb(dbname="mustache", "iriscouch")
#' }
#' @export
sofa_createdb <- function(dbname, endpoint="localhost", port=5984, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  
  if(endpoint=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s", port, dbname)
    fromJSON(content(PUT(call_)))
  } else
    if(endpoint=="cloudant"){
      auth <- get_pwd(username,pwd,"cloudant")
      url <- sprintf('https://%s:%s@%s.cloudant.com/%s', auth[[1]], auth[[2]], auth[[1]], dbname)
      out <- PUT(url, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
      fromJSON(content(out))
    } else
    {
      auth <- get_pwd(username,pwd,"iriscouch")
      url <- sprintf('https://%s.iriscouch.com/%s', auth[[1]], dbname)
      out <- PUT(url, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
      fromJSON(content(out))
    }
}