context("db_explain")

test_that("db_explain basic usage works", {
  skip_on_cran()

  file <- system.file("examples/omdb.json", package = "sofa")
  strs <- readLines(file)

  ## create a database
  if ("omdb" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname="omdb"))
  }
  invisible(db_create(sofa_conn, dbname='omdb'))

  ## add some documents
  invisible(db_bulk_create(sofa_conn, "omdb", strs))

  ## query all in one json blob
  aa <- db_explain(sofa_conn, dbname = "omdb", query = '{
             "selector": {
             "_id": {
             "$gt": null
             }
             }
  }', limit = 25)

	expect_is(aa, "list")
	expect_equal(aa$dbname, "omdb")
	expect_named(aa$selector, "_id")
	expect_named(aa$selector$`_id`, "$gt")
	expect_equal(aa$fields, "all_fields")

	cleanup_dbs("omdb")
})

test_that("db_explain fails well", {
	expect_error(db_explain(), "argument \"cushion\" is missing")
  expect_error(db_explain(sofa_conn), "argument \"dbname\" is missing")
})
