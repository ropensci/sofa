context("db_alldocs")

test_that("db_alldocs basic usage works", {
  skip_on_cran()

  aa <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 100)

	expect_is(aa, "list")
	expect_type(aa$total_rows, "integer")
	expect_type(aa$offset, "integer")
	expect_is(aa$rows, "list")
  expect_named(aa$rows[[1]], c('id', 'key', 'value'))
  expect_named(aa$rows[[1]]$value, 'rev')
})

test_that("db_alldocs - limit param works", {
  skip_on_cran()

  aa <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 3)
  bb <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 6)

  expect_equal(length(aa$rows), 3)
  expect_equal(length(bb$rows), 6)
})

test_that("db_alldocs - include_docs works", {
  skip_on_cran()

  bb <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 6, include_docs = TRUE)

  expect_is(bb, "list")
  expect_equal(length(bb$rows), 6)
})

test_that("db_alldocs fails well", {
	expect_error(db_alldocs(), "argument \"cushion\" is missing")
  expect_error(db_alldocs(sofa_conn), "argument \"dbname\" is missing")
})

