context("db_alldocs")

test_that("db_alldocs basic usage works", {
  skip_if_no_couchdb()

  aa <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 100)

	expect_is(aa, "list")
	expect_type(aa$total_rows, "integer")
	expect_type(aa$offset, "integer")
	expect_is(aa$rows, "list")
  expect_named(aa$rows[[1]], c('id', 'key', 'value'))
  expect_named(aa$rows[[1]]$value, 'rev')
})

test_that("db_alldocs - limit param works", {
  skip_if_no_couchdb()

  aa <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 3)
  bb <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 6)

  expect_equal(length(aa$rows), 3)
  expect_equal(length(bb$rows), 6)
})

test_that("db_alldocs - include_docs works", {
  skip_if_no_couchdb()

  bb <- db_alldocs(sofa_conn, dbname = db_test_name, limit = 6, include_docs = TRUE)

  expect_is(bb, "list")
  expect_equal(length(bb$rows), 6)
})

test_that("db_alldocs can return raw content and validates include_docs", {
  skip_if_no_couchdb()

  raw <- db_alldocs(sofa_conn, dbname = db_test_name, disk = tempfile())
  expect_type(raw, "raw")
  expect_error(db_alldocs(sofa_conn, db_test_name, include_docs = 1), "input must be of class logical")
})

test_that("db_alldocs fails well", {
  skip_if_no_couchdb()
  
	expect_error(db_alldocs(), "argument \"cushion\" is missing")
  expect_error(db_alldocs(sofa_conn), "argument \"dbname\" is missing")
})

