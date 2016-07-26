library("testthat")

invisible(x <- sofa::Cushion$new())

db <- "testing123"
if ("error" %in% names(db_info(x, db))) {
  db_create(x, dbname = db)
}
invisible(sofa::bulk_create(x, dbname = db, doc = iris))

test_check("sofa")
