#' List database info.
#'
#' @export
#' @param dbname Database name
#' @param endpoint One of localhost, cloudant, or iriscouch. For local work
#'    use the default localhost. For cloudant or iriscouch you will need accounts
#'    with those database services.
#' @param port The port to use. Only applicable if using endpoint="localhost".
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # local databasees
#' sofa_dbinfo(dbname="sofadb")
#'
#' # databasees on cloudant
#' ## passing username and password in function call
#' sofa_dbinfo("cloudant", username='yourusername', pwd='yourpassword')
#'
#' ## or setting username and password in options() call
#' cushion(cloudant_username='name', cloudant_pwd='pwd')
#' sofa_dbinfo("foobardb")
#' }

sofa_dbinfo <- function(dbname, endpoint="localhost", port=5984, username=NULL, pwd=NULL, ...)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  if(endpoint=="localhost"){
    sofa_GET(sprintf("http://127.0.0.1:%s/%s", port, dbname), ...)
  } else
    if(endpoint=="cloudant"){
      auth <- get_pwd(username,pwd,"cloudant")
      url <- sprintf('https://%s:%s@%s.cloudant.com/%s', auth[[1]], auth[[2]], auth[[1]], dbname)
      sofa_GET(url, add_headers("Content-Type" = "application/json"), ...)
    } else
    {
      auth <- get_pwd(username,pwd,"iriscouch")
      url <- sprintf('https://%s.iriscouch.com/%s', auth[[1]], dbname)
      sofa_GET(url, add_headers("Content-Type" = "application/json"), ...)
    }
}
