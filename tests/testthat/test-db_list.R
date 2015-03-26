context("db_list")

a <- db_list()

test_that("db_list doesn't fail", {
	expect_equal(a[1], "_replicator")
})

test_that("db_list returns the correct class", {
	expect_is(a, "character")
})
