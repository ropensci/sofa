#' List all databases.
#' 
#' @import httr rjson
#' @param endpoint One of localhost, cloudant, or iriscouch. For local work 
#'    use the default localhost. For cloudant or iriscouch you will need accounts 
#'    with those database services.
#' @param port The port to use. Only applicable if using endpoint="localhost".
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @examples \donttest{
#' # local databasees
#' sofa_listdbs()
#' 
#' # databasees on cloudant
#' ## passing username and password in function call
#' sofa_listdbs("cloudant", username='yourusername', pwd='yourpassword')
#' 
#' ## or setting username and password in options() call
#' cushion(cloudant_username='name', cloudant_pwd='pwd')
#' sofa_listdbs("cloudant")
#' }
#' @export
sofa_listdbs <- function(endpoint="localhost", port=5984, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  
  if(endpoint=="localhost"){
    endpoint <- "http://127.0.0.1"
    call_ <- paste(paste(endpoint, port, sep=":"), "/_all_dbs", sep="")
    fromJSON(content(GET(call_)))
  } else
    if(endpoint=="cloudant"){
      auth <- get_pwd(username,pwd,"cloudant")
      url <- sprintf('https://%s:%s@%s.cloudant.com/_all_dbs', auth[[1]], auth[[2]], auth[[1]])
      fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))
    } else
    {
      auth <- get_pwd(username,pwd,"iriscouch")
      url <- sprintf('https://%s.iriscouch.com/_all_dbs', auth[[1]])
      fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))
    }
}