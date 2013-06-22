# tests for sofa_alldocs fxn in taxize
context("sofa_alldocs")

# have to write new db b/c can't be sure of old dbs
sofa_createdb('testingdb')
sofa_writedoc(dbname='testingdb', doc='{"name":"dude","icecream":"rocky road"}')

test_that("sofa_alldocs returns the correct dimensions", {
	expect_that(nrow(sofa_alldocs(dbname="testingdb")), equals(1))
})

test_that("sofa_alldocs returns the correct class", {
	expect_that(sofa_alldocs(dbname="testingdb"), is_a("data.frame"))
})

sofa_deletedb('testingdb')