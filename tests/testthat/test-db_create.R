context("db_create")

test_that("db_create basic usage works", {
  skip_on_cran()

  if ("leothelion" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname = "leothelion"))
  }

  aa <- db_create(sofa_conn, dbname = 'leothelion')

	expect_is(aa, "list")
	expect_named(aa, "ok")
	expect_true(aa$ok)
})

test_that("db_create - json return works", {
  skip_on_cran()

  if ("leothelion-json" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname = "leothelion-json"))
  }

  aa <- db_create(sofa_conn, dbname = 'leothelion-json', as = "json")

  expect_is(aa, "character")
  expect_match(aa, "ok")
  expect_match(aa, "true")
})

test_that("db_create fails well", {
	expect_error(db_create(), "argument \"cushion\" is missing")
  expect_error(db_create(sofa_conn), "argument \"dbname\" is missing")

  if ("leothelion" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname = "leothelion"))
  }
  invisible(db_create(sofa_conn, "leothelion"))
  expect_error(db_create(sofa_conn, "leothelion"),
    "\\(412\\) - The database could not be created, the file already exists.")
})