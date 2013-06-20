#' List database info.
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
#' sofa_dbinfo(dbname="dudedb")
#' 
#' # databasees on cloudant
#' ## passing username and password in function call
#' sofa_dbinfo("cloudant", username='yourusername', pwd='yourpassword')
#' 
#' ## or setting username and password in options() call
#' options(cloudant.username="yourusername")
#' options(cloudant.pwd="yourpassword")
#' sofa_dbinfo("foobardb")
#' }
#' @export
sofa_dbinfo <- function(dbname, endpoint="localhost", port=5984, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  
  if(endpoint=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s", port, dbname)
    fromJSON(content(GET(call_)))
  } else
    if(endpoint=="cloudant"){
      if(is.null(username) | is.null(pwd))
        username <- getOption("cloudant.username")
        pwd <- getOption("cloudant.pwd")
        if(is.null(username) | is.null(pwd))
          stop("You must supply your username and password for Cloudant\nOptionally, set your username and password in options, see vignette")
      url <- sprintf('https://%s:%s@%s.cloudant.com/%s', username, pwd, username, dbname)
      fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))
    } else
      stop("iriscouch not supported yet")
}