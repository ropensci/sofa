context("db_changes")

test_that("db_changes basic usage works", {
  skip_on_cran()

  if ("leothelion" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname="leothelion"))
  }
  invisible(db_create(sofa_conn, dbname='leothelion'))

  # no changes
  aa <- db_changes(sofa_conn, dbname="leothelion")

  # create a document
  doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
  invisible(doc_create(sofa_conn, dbname="leothelion", doc1, docid="abeer"))

  # now there's changes
  bb <- db_changes(sofa_conn, dbname="leothelion")

	expect_is(aa, "list")
	expect_is(bb, "list")

	expect_equal(length(aa$results), 0)
	expect_equal(length(bb$results), 1)

	cleanup_dbs("leothelion")
})

test_that("db_changes - json return works", {
  skip_on_cran()

  if ("sss" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname="sss"))
  }
  invisible(db_create(sofa_conn, dbname='sss'))

  # no changes
  aa <- db_changes(sofa_conn, dbname="sss", as = "json")

  expect_is(aa, "character")
  expect_match(aa, "results")
  expect_match(aa, "pending")

  cleanup_dbs("sss")
})

test_that("db_changes fails well", {
	expect_error(db_changes(), "argument \"cushion\" is missing")
  expect_error(db_changes(sofa_conn), "argument \"dbname\" is missing")
})

