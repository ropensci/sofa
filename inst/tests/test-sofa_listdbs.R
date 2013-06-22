# tests for sofa_listbs fxn in sofa
context("sofa_listbs")

test_that("sofa_listbs returns the correct class", {
  expect_that(sofa_listdbs(), is_a("character"))
  expect_that(sofa_listdbs()[[1]], is_a("character"))
})