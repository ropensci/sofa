#' @examples \dontrun{
#' ## create a connection
#' user <- Sys.getenv("COUCHDB_TEST_USER")
#' pwd <- Sys.getenv("COUCHDB_TEST_PWD")
#' (x <- Cushion$new(user=user, pwd=pwd))
#'
#' file <- system.file("examples/omdb.json", package = "sofa")
#' strs <- readLines(file)
#'
#' ## create a database
#' if ("omdb" %in% db_list(x)) {
#'   invisible(db_delete(x, dbname="omdb"))
#' }
#' db_create(x, dbname='omdb')
#'
#' ## add some documents
#' invisible(db_bulk_create(x, "omdb", strs))
#'
#' ## query all in one json blob
#' db_query(x, dbname = "omdb", query = '{
#'   "selector": {
#'     "_id": {
#'       "$gt": null
#'     }
#'   }
#' }')
#'
#' ## query with each parameter
#' db_query(x, dbname = "omdb",
#'   selector = list(`_id` = list(`$gt` = NULL)))
#'
#' db_query(x, dbname = "omdb",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3)
#' 
#' # fields
#' ## single field works
#' db_query(x, dbname = "omdb",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3,
#'   fields = c('_id', 'Actors', 'imdbRating'))
#' 
#' ## as well as many fields
#' db_query(x, dbname = "omdb",
#'   selector = list(`_id` = list(`$gt` = NULL)), limit = 3,
#'   fields = '_id')
#'
#' ## other queries
#' db_query(x, dbname = "omdb",
#'   selector = list(Year = list(`$gt` = "2013")))
#'
#' db_query(x, dbname = "omdb", selector = list(Rated = "R"))
#'
#' db_query(x, dbname = "omdb",
#'   selector = list(Rated = "PG", Language = "English"))
#'
#' db_query(x, dbname = "omdb", selector = list(
#'   `$or` = list(
#'     list(Director = "Jon Favreau"),
#'     list(Director = "Spike Lee")
#'   )
#' ), fields = c("_id", "Director"))
#'
#' ## when selector vars are of same name, use a JSON string
#' ## b/c R doesn't let you have a list with same name slots
#' db_query(x, dbname = "omdb", query = '{
#'   "selector": {
#'     "Year": {"$gte": "1990"},
#'     "Year": {"$lte": "2000"},
#'     "$not": {"Year": "1998"}
#'   },
#'   "fields": ["_id", "Year"]
#' }')
#'
#' ## regex
#' db_query(x, dbname = "omdb", selector = list(
#'   Director = list(`$regex` = "^R")
#' ), fields = c("_id", "Director"))
#'
#' }
