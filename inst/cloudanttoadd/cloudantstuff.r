# library(httr); library(rjson)

# Retrieving a list of all databases
# url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/_all_dbs'
# fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))

# Retrieving information about a database
# url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/foobardb'
# fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))

#' Creating a database
#' The database name must be composed of one or more of the following characters:
#' • Lowercase characters (a-z)
#' • Name must begin with a lowercase letter
#' • Digits (0-9)
#' • Any of the characters _, $, (, ), +, -, and /.
#' 
# url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/mynewdb'
# fromJSON(content(PUT(url, add_headers("Content-Type" = "application/json"))))

#' Deleting a database
# url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/mynewdb'
# content(DELETE(url, add_headers("Content-Type" = "application/json")))

# #' Upload a local database to Cloudant
# #' DB has to exist locally and you have to create the database on Cloudant first before uploadingn local database
# #' it takes a while to respond, longer as database is bigger
# ## create new database on cloudant
# url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/foobardb'
# fromJSON(content(PUT(url, add_headers("Content-Type" = "application/json"))))
# 
# ## upload local database of same name to cloudant
# url <- 'http://localhost:5984/_replicate'
# args <- toJSON(list(source="foobardb", target="https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/foobardb"))
# fromJSON(content(POST(url, add_headers("Content-Type" = "application/json"), args)))




############################
## these not implemented yet
#' Retrieving multiple documents in one request
#' @param descending Return the documents in descending by key order, Optional, boolean, Default: false
#' @param endkey Stop returning records when the speciﬁed key is reached, Optional
#' @param endkey_docid Stop returning records when the speciﬁed document ID is reached, Optional
#' @param group Group the results using the reduce function to a group or single row, Optional, boolean, Default: false
#' @param group_level Specify the group level to be used, Optional, numeric
#' @param include_docs Include the full content of the documents in the return, Optional, boolean, Default: false
#' @param inclusive_end Speciﬁes whether the speciﬁed end key should be included in the result, Optional, boolean, Default: true
#' @param key Return only documents that match the speciﬁed key, Optional, string
#' @param limit Limit the number of the returned documents to the speciﬁed number, Optional, numeric
#' @param reduce Use the reduction function, Optional, boolean, Default: true
#' @param skip Skip this number of records before starting to return the results, Optional, numeric, Default: 0
#' @param stale Allow the results from a stale view to be used, Optional
#' @param startkey Return records starting with the speciﬁed key, Optional
#' @param startkey_docid Return records starting with the speciﬁed document ID, Optional
url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/dudedb/_all_docs'
fromJSON(content(GET(url, add_headers("Content-Type" = "application/json"))))

#' Retrieving multiple documents in one request - POST
#' The POST to _all_docs allows to specify multiple keys to be selected from the database. The request body should contain a list of the keys to be returned as an array to a keys object.
url <- 'https://ropensci:eBT4Qjw4npZTibR@ropensci.cloudant.com/dudedb/_all_docs'
keys <- toJSON(list(keys = c('6ab1c1f841767839655dd274ae81c173','6ab1c1f841767839655dd274ae799431')))
fromJSON(content(POST(url, add_headers("Content-Type" = "application/json"), body=keys)))