library("httr")

invisible(sofa_conn <- sofa::Cushion$new())

db_test_name <- "testing123"
if (!db_test_name %in% sofa::db_list(sofa_conn)) {
  sofa::db_create(sofa_conn, dbname = db_test_name)
}
invisible(sofa::db_bulk_create(sofa_conn, dbname = db_test_name, doc = iris))
