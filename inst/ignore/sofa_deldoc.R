# tests for sofa_deldoc fxn in taxize
context("sofa_deldoc")

# create a db and document
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
sofa_createdb("deldoctesting")
sofa_writedoc(dbname="deldoctesting", doc=doc3, docid="somexml")

test_that("sofa_deldoc returns a message", {
  expect_that(sofa_deldoc(dbname="deldoctesting", docid="somexml"), shows_message())
})

sofa_writedoc(dbname="deldoctesting", doc=doc3, docid="somexml")

test_that("sofa_deldoc returns a message and the right message", {
  expect_that(sofa_deldoc(dbname="deldoctesting", docid="somexml"), shows_message("somexml deleted"))
})

sofa_writedoc(dbname="deldoctesting", doc=doc3, docid="somexml")

test_that("sofa_deldoc returns the correct class", {
  expect_that(sofa_deldoc(dbname='deldoctesting', docid="somexml"), is_a("NULL"))
})

sofa_deletedb('deldoctesting')