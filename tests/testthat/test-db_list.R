context("db_list")

test_that("db_list returns the correct class", {
  skip_on_cran()

	expect_is(db_list(sofa_conn), "character")
  expect_gt(length(db_list(sofa_conn)), 0)
})

test_that("db_list fails well", {
	expect_error(db_list(5), "input must be a sofa Cushion object")
})

