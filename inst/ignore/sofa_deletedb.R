# tests for sofa_deletedb fxn in sofa
context("sofa_deletedb")

# create a db
sofa_createdb("deldbtesting")

test_that("sofa_deletedb returns a character of length 1", {
  expect_that(length(sofa_deletedb("deldbtesting")), equals(1))
})

sofa_createdb("deldbtesting")

test_that("sofa_deletedb returns the right characters", {
  expect_that(sofa_deletedb("deldbtesting"), matches(""))
})

sofa_createdb("deldbtesting")

test_that("sofa_deletedb returns the correct class", {
  expect_that(sofa_deletedb('deldoctesting'), is_a("character"))
  expect_that(sofa_deletedb('deldoctesting_absent'), is_a("character"))
})