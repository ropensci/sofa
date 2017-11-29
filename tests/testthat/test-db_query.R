context("db_query")

local({
  skip_on_cran()
  file <- system.file("examples/omdb.json", package = "sofa")
  strs <- readLines(file)

  ## create a database
  if ("omdb" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname = "omdb"))
  }
  invisible(db_create(sofa_conn, dbname = 'omdb'))

  ## add some documents
  invisible(db_bulk_create(sofa_conn, "omdb", strs))
})

test_that("db_query - selector param works", {
  skip_on_cran()

  aa <- db_query(sofa_conn, 'omdb', selector = list(`_id` = list(`$gt` = NULL)))

	expect_is(aa, "list")
	expect_true('docs' %in% names(aa))
  expect_is(aa$docs, 'list')
  expect_is(aa$docs[[1]], "list")

  expect_true(all(c("Title", "Writer", "imdbRating") %in% names(aa$docs[[1]])))
})

test_that("db_query - query as text string works", {
  skip_on_cran()

  aa <- db_query(
    sofa_conn, 'omdb', query = '{
      "selector": {
        "_id": {
          "$gt": null
        }
      }
    }'
  )

  expect_is(aa, "list")
  expect_true('docs' %in% names(aa))
  expect_is(aa$docs, 'list')
  expect_is(aa$docs[[1]], "list")

  expect_true(all(c("Title", "Writer", "imdbRating") %in% names(aa$docs[[1]])))
})

test_that("db_query - a regex query works", {
  skip_on_cran()

  aa <- db_query(
    sofa_conn, 'omdb', selector = list(
      Director = list(`$regex` = "^R")
    )
  )

  expect_is(aa, "list")
  expect_true('warning' %in% names(aa))
  expect_true('docs' %in% names(aa))
  expect_is(aa$docs, 'list')
  expect_is(aa$docs[[1]], "list")

  expect_equal(length(aa$docs), 11)

  expect_true(all(c("Title", "Writer", "imdbRating") %in% names(aa$docs[[1]])))
})

test_that("db_query - fields param works", {
  skip_on_cran()

  aa <- db_query(
    sofa_conn, dbname = "omdb", selector = list(
      Director = list(`$regex` = "^R")
    ), fields = c("_id", "Director"))

  expect_is(aa, "list")
  expect_true('warning' %in% names(aa))
  expect_true('docs' %in% names(aa))
  expect_is(aa$docs, 'list')
  expect_is(aa$docs[[1]], "list")

  expect_equal(length(aa$docs), 11)

  expect_true(all(c("_id", "Director") %in% names(aa$docs[[1]])))
})

test_that("db_query fails well", {
  expect_error(db_query(), "argument \"cushion\" is missing")
  expect_error(db_query(sofa_conn), "argument \"dbname\" is missing")

  skip_on_cran()
  expect_error(db_query(sofa_conn, "asdfds"), "Database does not exist")
})

cleanup_dbs("omdb")
