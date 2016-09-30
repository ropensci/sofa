library("httr")

skip_on_travis()

invisible(sofa_conn <- sofa::Cushion$new())

db <- "testing123"
if (!db %in% sofa::db_list(sofa_conn)) {
  sofa::db_create(sofa_conn, dbname = db)
}
invisible(sofa::bulk_create(sofa_conn, dbname = db, doc = iris))
