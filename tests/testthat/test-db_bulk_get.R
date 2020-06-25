test_that("db_bulk_get", {
  skip_on_cran()

  if ("bulkgettest" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname="bulkgettest"))
  }
  db_create(sofa_conn, dbname = "bulkgettest")
  db_bulk_create(sofa_conn, "bulkgettest", mtcars)
  res <- db_query(sofa_conn, dbname = "bulkgettest", selector = list(cyl = 8))
  ids <- vapply(res$docs, "[[", "", "_id")
  ids_only <- lapply(ids[1:5], function(w) list(id = w))

  aa <- db_bulk_get(sofa_conn, "bulkgettest", docid_rev = ids_only)

	expect_is(aa, "list")
	expect_named(aa, "results")
  expect_equal(length(aa), 1)
  expect_equal(length(aa$results), 5)
	expect_type(aa[[1]], "list")
  expect_named(aa[[1]], NULL)
  expect_named(aa[[1]][[1]], c("id", "docs"))
  expect_is(aa[[1]][[1]]$id, "character")
  expect_is(aa[[1]][[1]]$docs, "list")

  cleanup_dbs("bulkgettest")
})

test_that("db_bulk_get fails well", {
  expect_error(db_bulk_get(), "argument \"cushion\" is missing")
  
  skip_on_cran()
  
  expect_error(db_bulk_get(sofa_conn), "argument \"dbname\" is missing")
  expect_error(db_bulk_get(sofa_conn, "stuff"),
    "argument \"docid_rev\" is missing")
  expect_error(db_bulk_get(sofa_conn, "asdfds", "adsfsdf"),
    "Database does not exist")
})
