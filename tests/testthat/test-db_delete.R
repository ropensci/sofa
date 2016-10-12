context("db_delete")

test_that("db_delete basic usage works", {
  skip_on_cran()

  dbn <- dbname_random()
  invisible(db_create(sofa_conn, dbname = dbn))

  aa <- db_delete(sofa_conn, dbname = dbn)

	expect_is(aa, "list")
	expect_named(aa, "ok")
	expect_true(aa$ok)
})

test_that("db_delete - json return works", {
  skip_on_cran()

  dbn <- dbname_random()
  invisible(db_create(sofa_conn, dbname = dbn))

  aa <- db_delete(sofa_conn, dbname = dbn, as = "json")

  expect_is(aa, "character")
  expect_match(aa, "ok")
  expect_match(aa, "true")
})

test_that("db_delete fails well", {
	expect_error(db_delete(), "argument \"cushion\" is missing")
  expect_error(db_delete(sofa_conn), "argument \"dbname\" is missing")

  skip_on_cran()
  dbn <- dbname_random()
  invisible(db_create(sofa_conn, dbname = dbn))
  invisible(db_delete(sofa_conn, dbn))
  expect_error(db_delete(sofa_conn, dbn), "\\(404\\) - Database does not exist.")
})
