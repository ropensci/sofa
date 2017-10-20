dbname_random <- function() {
  paste0(sample(letters, 10, replace = TRUE), collapse = '')
}

cleanup_dbs <- function(x) invisible(db_delete(sofa_conn, x))

invisible(sofa_conn <- sofa::Cushion$new())
pinged <- tryCatch(sofa_conn$ping(), error = function(e) e)
if (!inherits(pinged, "error")) {
	db_test_name <- "testing123"
	if (!db_test_name %in% sofa::db_list(sofa_conn)) {
	  sofa::db_create(sofa_conn, dbname = db_test_name)
	}
	invisible(sofa::db_bulk_create(sofa_conn, dbname = db_test_name, doc = iris))
}
