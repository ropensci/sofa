library("testthat")
library("sofa")

invisible(x <- sofa::Cushion$new())

db <- "testing123"
if ("error" %in% names(sofa::db_info(x, db))) {
  sofa::db_create(x, dbname = db)
}
invisible(sofa::bulk_create(x, dbname = db, doc = iris))

test_check("sofa")
