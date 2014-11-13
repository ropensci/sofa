#' List all databases.
#'
#' @export
#' @param endpoint One of localhost, cloudant, or iriscouch. For local work
#'    use the default localhost. For cloudant or iriscouch you will need accounts
#'    with those database services.
#' @param port The port to use. Only applicable if using endpoint="localhost".
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # local databasees
#' listdbs()
#'
#' # databasees on cloudant
#' ## passing username and password in function call
#' listdbs("cloudant", username='yourusername', pwd='yourpassword')
#'
#' ## or setting username and password in options() call
#' cushion(cloudant_username='name', cloudant_pwd='pwd')
#' listdbs("cloudant")
#'
#' # different login credentials than normal, just pass in to function call
#' listdbs("cloudant", username='appid.heroku', pwd='password')
#' }

listdbs <- function(endpoint="localhost", port=5984, username=NULL, pwd=NULL, ...)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))

  if(endpoint=="localhost"){
    endpoint <- "http://127.0.0.1"
    call_ <- paste(paste(endpoint, port, sep=":"), "/_all_dbs", sep="")
    sofa_GET(call_, ...)
  } else
    if(endpoint=="cloudant"){
      if(is.null(username) | is.null(pwd)){
        auth <- get_pwd(username,pwd,"cloudant")
      } else { auth <- c(username, pwd) }
      url <- sprintf('https://%s:%s@%s.cloudant.com/_all_dbs', auth[[1]], auth[[2]], auth[[1]])
      sofa_GET(url, content_type_json(), ...)
    } else
    {
      if(is.null(username) | is.null(pwd)){
        auth <- get_pwd(username,pwd,"iriscouch")
      } else { auth <- c(username, pwd) }
      url <- sprintf('https://%s.iriscouch.com/_all_dbs', auth[[1]])
      sofa_GET(url, content_type_json(), ...)
    }
}
