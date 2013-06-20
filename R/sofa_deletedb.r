#' Delete a database.
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
#' sofa_deletedb(dbname="shitbutt")
#'
#' ## or setting username and password in options() call
#' options(cloudant.username="yourusername")
#' options(cloudant.pwd="yourpassword")
#' sofa_deletedb(dbname="foobardb", "cloudant")
#' }
#' @export
sofa_deletedb <- function(dbname, endpoint="localhost", port=5984, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  
  if(endpoint=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s", port, dbname)
    content(DELETE(call_))
  } else
    if(endpoint=="cloudant"){
      if(is.null(username) | is.null(pwd)){
        username <- getOption("cloudant.username")
        pwd <- getOption("cloudant.pwd")
        if(is.null(username) | is.null(pwd))
          stop("You must supply your username and password for Cloudant\nOptionally, set your username and password in options, see vignette")
      }
      url <- sprintf('https://%s:%s@%s.cloudant.com/%s', username, pwd, username, dbname)
      out <- DELETE(url, add_headers("Content-Type" = "application/json"))
      stop_for_status(out)
    } else
      stop("iriscouch not supported yet")
}