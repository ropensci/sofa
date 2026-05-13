context("db_list")

test_that("db_list returns the correct class", {
  skip_if_no_couchdb()

	expect_is(db_list(sofa_conn), "character")
  expect_gt(length(db_list(sofa_conn)), 0)
})

test_that("db_list can return unsimplified list and json", {
  skip_if_no_couchdb()

  expect_is(db_list(sofa_conn, simplify = FALSE), "list")
  expect_is(db_list(sofa_conn, as = "json"), "character")
})

test_that("db_list fails well", {
	expect_error(db_list(5), "input must be a sofa Cushion object")
})

