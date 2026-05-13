library(sofa)

envvar <- function(x, default = NULL) {
  value <- Sys.getenv(x)
  if (nzchar(value)) value else default
}

COUCHDB_TEST_HOST <- envvar("COUCHDB_TEST_HOST", "127.0.0.1")
COUCHDB_TEST_USER <- envvar("COUCHDB_TEST_USER")
COUCHDB_TEST_PWD <- envvar("COUCHDB_TEST_PWD")
COUCHDB_TEST_TRANSPORT <- envvar("COUCHDB_TEST_TRANSPORT", "http")
COUCHDB_TEST_PORT <- envvar("COUCHDB_TEST_PORT", "5984")
COUCHDB_TEST_PORT <- if (is.null(COUCHDB_TEST_PORT)) NULL else as.integer(COUCHDB_TEST_PORT)

dbname_random <- function() {
  paste0(sample(letters, 10, replace = TRUE), collapse = "")
}

cleanup_dbs <- function(x) invisible(db_delete(sofa_conn, x))

sofa_args <- list(
  host = COUCHDB_TEST_HOST,
  transport = COUCHDB_TEST_TRANSPORT,
  port = COUCHDB_TEST_PORT
)
if (!is.null(COUCHDB_TEST_USER) && !is.null(COUCHDB_TEST_PWD)) {
  sofa_args$user <- COUCHDB_TEST_USER
  sofa_args$pwd <- COUCHDB_TEST_PWD
}

invisible(sofa_conn <- do.call(Cushion$new, sofa_args))

pinged <- tryCatch(sofa_conn$ping(), error = function(e) e)

skip_if_no_couchdb <- function() {
  testthat::skip_if(
    inherits(pinged, "error"),
    paste("CouchDB test server is not available at", sofa_conn$make_url())
  )
}

if (!inherits(pinged, "error")) {
  db_test_name <- "testing123"
  if (!db_test_name %in% db_list(sofa_conn)) {
    db_create(sofa_conn, dbname = db_test_name)
  }
  invisible(db_bulk_create(sofa_conn, dbname = db_test_name, doc = iris))
}

