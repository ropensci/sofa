# tests for sofa_createdb fxn in taxize
context("sofa_createdb")

test_that("sofa_alldocs returns the correct dimensions", {
  expect_that(length(sofa_createdb('testingdb2')), equals(1))
  expect_that(length(sofa_createdb('testingdb2')), equals(2))
})

test_that("sofa_alldocs returns the correct class", {
  expect_that(sofa_createdb("testingdb3"), is_a("list"))
  expect_that(sofa_createdb("testingdb3")[[1]], matches("file_exists"))
})

sofa_deletedb('testingdb2')
sofa_deletedb('testingdb3')