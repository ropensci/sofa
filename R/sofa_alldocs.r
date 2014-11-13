#' List all docs in a given database.
#'
#' @export
#' @import plyr
#' @importFrom jsonlite fromJSON
#' @inheritParams sofa_ping
#' @param dbname Database name. (charcter)
#' @param asdf Return as data.frame? defaults to TRUE (logical)
#' @param descending Return in descending order? (logical)
#' @param startkey Document ID to start at. (character)
#' @param endkey Document ID to end at. (character)
#' @param limit Number document IDs to return. (numeric)
#' @param include_docs If TRUE, returns docs themselves, in addition to IDs (logical)
#' @param ... Curl args passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' sofa_alldocs(dbname="sofadb")
#' sofa_alldocs(dbname="mydb", limit=2)
#' sofa_alldocs(dbname="mydb", limit=2, include_docs="true")
#' library('httr')
#' sofa_alldocs(dbname="sofadb", config=verbose())
#'
#' # different login credentials than normal, just pass in to function call
#' ## you obviously need to fill in some details here, this won't work as is
#' sofa_alldocs(cushion="sofa_cloudant", dbname='dbname', username='username', pwd='password')
#'
#' # this works for the package author, but not for you
#' cushion(sofa_cloudant_heroku=c('<name>','<pwd>'))
#' sofa_alldocs(cushion="sofa_cloudant_heroku", dbname='gaugesdb_ro', include_docs='true')
#' }

sofa_alldocs <- function(cushion="sofa_localhost", port=5984, dbname, asdf = TRUE,
  descending=NULL, startkey=NULL, endkey=NULL, limit=NULL, include_docs=NULL,
  username=NULL, pwd=NULL, ...)
{
  choices <- c("sofa_localhost","sofa_cloudant","sofa_iriscouch")
  thing <- paste0(strsplit(cushion,'_')[[1]][1:2],collapse="_")
  base_serv <- choices[agrep(thing, choices, ignore.case=TRUE)]
  args <- sc(list(descending=descending, startkey=startkey,endkey=endkey,
                       limit=limit,include_docs=include_docs))

  if(base_serv=="sofa_localhost"){
    call_ <- sprintf("http://127.0.0.1:%s/%s/_all_docs", port, dbname)
    temp <- sofa_GET(call_, args, ...)
  } else
    if(base_serv=="sofa_cloudant"){
      if(is.null(username) | is.null(pwd)){ auth <- get_pwd(username,pwd,cushion) } else { auth <- c(username, pwd) }
      url <- sprintf('https://%s:%s@%s.cloudant.com/%s/_all_docs', auth[[1]], auth[[2]], auth[[1]], dbname)
      temp <- sofa_GET(url, args, add_headers("Content-Type" = "application/json"), ...)
    } else
      if(base_serv=="sofa_iriscouch"){
        if(is.null(username) | is.null(pwd)){ auth <- get_pwd(username,pwd,cushion) } else { auth <- c(username, pwd) }
        url <- sprintf('https://%s.iriscouch.com/%s/_all_docs', auth[[1]], dbname)
        temp <- sofa_GET(url, args, add_headers("Content-Type" = "application/json"), ...)
      } else
        stop(paste0(base_serv, " is not supported yet"))

  if(asdf & is.null(include_docs)){
    return( ldply(temp$rows, function(x) as.data.frame(x)) )
  } else
  { temp }
}
