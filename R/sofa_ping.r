#' Ping the couchdb server.
#' 
#' @param endpoint the endpoint, defaults to localhost (http://127.0.0.1)
#' @param port port to connect to, defaults to 5984
#' @param username Your cloudant or iriscouch username
#' @param pwd Your cloudant or iriscouch password
#' @examples
#' sofa_ping()
#' @export
sofa_ping <- function(endpoint="localhost", port=5984, username=NULL, pwd=NULL)
{
  endpoint <- match.arg(endpoint,choices=c("localhost","cloudant","iriscouch"))
  
  if(endpoint=="localhost"){
    call_ <- sprintf("http://127.0.0.1:%s", port)
    fromJSON(content(GET(call_), as="text"))
  } else
    if(endpoint=="cloudant"){
      auth <- get_pwd(username,pwd,"cloudant")
      call_ <- sprintf('https://%s:%s@%s.cloudant.com', auth[[1]], auth[[2]], auth[[1]])
      fromJSON(content(GET(call_), as="text"))
    } else
    {
      auth <- get_pwd(username,pwd,"iriscouch")
      call_ <- sprintf('https://%s.iriscouch.com', auth[[1]])
      fromJSON(content(GET(call_), as="text"))
    }  
}