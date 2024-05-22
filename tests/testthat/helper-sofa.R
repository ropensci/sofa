library(sofa)
COUCHDB_TEST_HOST <- Sys.getenv("COUCHDB_TEST_HOST")
COUCHDB_TEST_USER <- Sys.getenv("COUCHDB_TEST_USER")
COUCHDB_TEST_PWD <- Sys.getenv("COUCHDB_TEST_PWD")

dbname_random <- function() {
  paste0(sample(letters, 10, replace = TRUE), collapse = "")
}

cleanup_dbs <- function(x) invisible(db_delete(sofa_conn, x))

invisible(sofa_conn <- Cushion$new(
  host = COUCHDB_TEST_HOST,
  user = COUCHDB_TEST_USER,
  pwd = COUCHDB_TEST_PWD,
  transport = 'https',
  port = 443
))

pinged <- tryCatch(sofa_conn$ping(), error = function(e) e)

if (!inherits(pinged, "error")) {
  db_test_name <- "testing123"
  if (!db_test_name %in% db_list(sofa_conn)) {
    db_create(sofa_conn, dbname = db_test_name)
  }
  invisible(db_bulk_create(sofa_conn, dbname = db_test_name, doc = iris))
}

