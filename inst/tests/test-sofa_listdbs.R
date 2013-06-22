# tests for sofa_head fxn in taxize
context("sofa_head")

# create a db and document
doc1 <- '{"name":"dude","beer":"IPA"}'
sofa_createdb("headtesting")
sofa_writedoc(dbname="headtesting", doc=doc1, docid="mydoc")

test_that("sofa_head returns list of right length", {
  expect_that(length(sofa_head(dbname="headtesting", docid="mydoc")), equals(8))
})

test_that("sofa_head returns correct values", {
  expect_that(sofa_head(dbname="headtesting", docid="mydoc")[["status"]], matches("200"))
  expect_that(sofa_head(dbname="headtesting", docid="mydoc")[["statusmessage"]], matches("OK"))
  expect_that(sofa_head(dbname="headtesting", docid="mydoc")[["content-length"]], matches("87"))
})

test_that("sofa_head returns the correct class", {
  expect_that(sofa_head(dbname="headtesting", docid="mydoc"), is_a("list"))
  expect_that(sofa_head(dbname="headtesting", docid="mydoc")[['server']], is_a("character"))
})

# clean up
sofa_deletedb('headtesting')