# tests for sofa_dbinfo fxn in taxize
context("sofa_dbinfo")

# create a db
sofa_createdb('testingdb4')

test_that("sofa_dbinfo returns the correct dimensions", {
  expect_that(length(sofa_dbinfo('testingdb4')), equals(11))
  expect_that(length(sofa_dbinfo('testingdb4')), equals(2))
})

test_that("sofa_alldocs returns the correct class", {
  expect_that(sofa_dbinfo('testingdb4'), is_a("list"))
  expect_that(sofa_dbinfo('testingdb4')[["db_name"]], is_a("character"))
  expect_that(sofa_dbinfo('testingdb4')[["doc_count"]], is_a("numeric"))
  expect_that(sofa_dbinfo('testingdb4')[["compact_running"]], is_a("logical"))
  expect_that(sofa_dbinfo("testingdb4")[["db_name"]], matches("testingdb4"))
})

sofa_deletedb('testingdb4')