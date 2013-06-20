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
#' options(cloudant.username="yourusername")
#' options(cloudant.pwd="yourpassword")
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
      if(is.null(username) | is.null(pwd))
        username <- getOption("cloudant.username")
        pwd <- getOption("cloudant.pwd")
        if(is.null(username) | is.null(pwd))
          stop("You must supply your username and password for Cloudant\nOptionally, set your username and password in options, see vignette")
      url <- sprintf('https://%s:%s@%s.cloudant.com/_all_dbs', username, pwd, username)
      fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))
    } else
      stop("iriscouch not supported yet")
}