context("design_search_many")

local({
  skip_if_no_couchdb()
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

test_that("design_search_many", {
  skip_if_no_couchdb()

  design_create_(sofa_conn, dbname='omdb', design='view6', fxnname="foobar4",
    fxn = "function(doc){emit(doc._id,doc.Country)}")
  ids <- vapply(db_alldocs(sofa_conn, dbname='omdb')$rows[1:3], "[[", "", "id")
  queries <- list(
    list(keys = ids),
    list(limit = 3, skip = 2)
  )
  res <- design_search_many(sofa_conn, 'omdb', 'view6', 'foobar4', queries)

  expect_is(res, "list")
  expect_named(res, "results")
  expect_named(res$results, NULL)
  expect_is(res$results[[1]], "list")
  expect_named(res$results[[1]], c("total_rows", "offset", "rows"))
  expect_type(res$results[[1]]$total_rows, "integer")
  expect_type(res$results[[1]]$offset, "integer")
  expect_is(res$results[[1]]$rows, "list")
  expect_named(res$results[[1]]$rows, NULL)
  expect_is(res$results[[1]]$rows[[1]], "list")
  expect_named(res$results[[1]]$rows[[1]], c("id", "key", "value"))
})

test_that("design_search_many supports CouchDB versions before 2.2", {
  skip_if_no_couchdb()

  old_version <- sofa_conn$version
  unlockBinding("version", sofa_conn)
  sofa_conn$version <- function() 210
  on.exit({
    sofa_conn$version <- old_version
    lockBinding("version", sofa_conn)
  }, add = TRUE)

  ids <- vapply(db_alldocs(sofa_conn, dbname = "omdb")$rows[1:2], "[[", "", "id")
  res <- design_search_many(
    sofa_conn, "omdb", "view6", "foobar4",
    list(list(keys = ids))
  )

  expect_named(res, c("total_rows", "offset", "rows"))
})

test_that("design_search_many fails well", {
  skip_if_no_couchdb()

  expect_error(design_search_many(), "argument \"cushion\" is missing")
  expect_error(design_search_many(sofa_conn), "argument \"dbname\" is missing")
  expect_error(design_search_many(sofa_conn, "asdfds"),
    "argument \"design\" is missing")
  expect_error(design_search_many(sofa_conn, "asdfds", "ad"),
    "argument \"view\" is missing")
  expect_error(design_search_many(sofa_conn, "asdfds", "ad", "adf"),
    "argument \"queries\" is missing")
})

cleanup_dbs("omdb")
