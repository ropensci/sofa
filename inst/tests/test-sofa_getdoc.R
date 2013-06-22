# tests for sofa_getdoc fxn in sofa
context("sofa_getdoc")

# create a db, write a doc
sofa_createdb("getdoctesting")
sofa_writedoc(dbname="getdoctesting", doc='{"name":"dude","beer":"IPA"}', docid='thingsandstuff')

test_that("sofa_getdoc returns a vector of correct length", {
  expect_that(length(sofa_getdoc(dbname="getdoctesting", docid="thingsandstuff")), equals(4))
})

test_that("sofa_getdoc returns the right characters", {
  expect_that(sofa_getdoc(dbname="getdoctesting", docid="thingsandstuff")[["beer"]], matches("IPA"))
})

test_that("sofa_getdoc returns the correct class", {
  expect_that(sofa_getdoc(dbname="getdoctesting", docid="thingsandstuff"), is_a("list"))
  expect_that(sofa_getdoc(dbname="getdoctesting", docid="thingsandstuff")[[1]], is_a("character"))
})

sofa_deletedb('getdoctesting')