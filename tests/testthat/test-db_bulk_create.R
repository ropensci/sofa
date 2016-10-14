context("db_bulk_create")

test_that("db_bulk_create basic usage works", {
  skip_on_cran()

  if ("bulktest" %in% db_list(sofa_conn)) {
     invisible(db_delete(sofa_conn, dbname = "bulktest"))
  }
  db_create(sofa_conn, dbname = "bulktest")
  aa <- db_bulk_create(sofa_conn, "bulktest", mtcars)

	expect_is(aa, "list")
	expect_null(names(aa))
	expect_type(aa[[1]], "list")
  expect_named(aa[[1]], c('ok', 'id', 'rev'))
  expect_true(aa[[1]]$ok)
  expect_is(aa[[1]]$id, "character")
  expect_is(aa[[1]]$rev, "character")

  cleanup_dbs("bulktest")
})

test_that("db_bulk_create fails well", {
  expect_error(db_bulk_create(), "argument \"cushion\" is missing")
  expect_error(db_bulk_create(sofa_conn), "argument \"doc\" is missing")
  expect_error(db_bulk_create(sofa_conn, "stuff"), "argument \"doc\" is missing")

  skip_on_cran()
  expect_error(db_bulk_create(sofa_conn, "asdfds", "adsfsdf"), "Database does not exist")
})
