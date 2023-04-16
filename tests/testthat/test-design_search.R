context("design_search")

local({
  skip_on_cran()
  skip_if_no_couch(pinged)
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

test_that("design_search", {
  skip_on_cran()
  skip_if_no_couch(pinged)

  design_create(sofa_conn, dbname='omdb', design='view5', fxnname="foobar3",
    value="[doc.Country,doc.imdbRating]")
  res <- design_search(sofa_conn, dbname='omdb', design='view5', view = 'foobar3')
  df = structure(do.call(
    "rbind.data.frame",
    lapply(res$rows, function(x) x$value)
  ), .Names = c('Country', 'imdbRating'))

  expect_is(res, "list")
  expect_named(res, c("total_rows", "offset", "rows"))
  expect_type(res$total_rows, "integer")
  expect_type(res$offset, "integer")
  expect_is(res$rows, "list")
  expect_named(res$rows, NULL)
  expect_is(res$rows[[1]], "list")
  expect_named(res$rows[[1]], c("id", "key", "value"))

  expect_is(df, "data.frame")
  expect_named(df, c("Country", "imdbRating"))
})

test_that("design_search fails well", {
  skip_on_cran()
  skip_if_no_couch(pinged)

  expect_error(design_search(), "argument \"cushion\" is missing")
  expect_error(design_search(sofa_conn), "argument \"dbname\" is missing")
  expect_error(design_search(sofa_conn, "asdfds"),
    "argument \"design\" is missing")
  expect_error(design_search(sofa_conn, "asdfds", "ad"),
    "argument \"view\" is missing")
  expect_error(design_search(sofa_conn, "asdfds", "ad", "adf"),
    "does not exist")
})

cleanup_dbs("omdb")
