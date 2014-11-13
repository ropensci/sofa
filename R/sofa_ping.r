#' Ping a couchdb server.
#'
#' @export
#' @param endpoint the endpoint, defaults to localhost (http://127.0.0.1)
#' @param port port to connect to, defaults to 5984
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @param
#' @examples \donttest{
#' sofa_ping()
#' # sofa_ping("sofa_cloudant_heroku")
#' }
sofa_ping <- function(endpoint="localhost", port=5984, username=NULL, pwd=NULL, ...)
{
  endpoint <- match.arg(endpoint, choices=c("localhost","cloudant","iriscouch"))

  if(endpoint=="localhost"){
    sofa_GET(sprintf("http://127.0.0.1:%s", port), ...)
  } else
    if(endpoint=="cloudant"){
      auth <- get_pwd(username, pwd, "cloudant")
      call_ <- sprintf('https://%s:%s@%s.cloudant.com', auth[[1]], auth[[2]], auth[[1]])
      sofa_GET(call_, ...)
    } else
    {
      auth <- get_pwd(username,pwd,"iriscouch")
      sofa_GET(sprintf('https://%s.iriscouch.com', auth[[1]]), ...)
    }
}
