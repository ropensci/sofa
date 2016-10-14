context("db_info")

test_that("db_info basic usage works", {
  skip_on_cran()

  db <- dbname_random()
  if (db %in% db_list(sofa_conn)) {
     invisible(db_delete(sofa_conn, dbname = db))
  }
  invisible(db_create(sofa_conn, dbname = db))

  aa <- db_info(sofa_conn, db)

	expect_is(aa, "list")
	expect_equal(aa$db_name, db)
  expect_is(aa$sizes, 'list')
  expect_equal(aa$doc_count, 0)
  expect_equal(aa$doc_del_count, 0)
  expect_equal(aa$data_size, 0)

  cleanup_dbs(db)
})

test_that("db_info fails well", {
  expect_error(db_info(), "argument \"cushion\" is missing")
  expect_error(db_info(sofa_conn), "argument \"dbname\" is missing")

  skip_on_cran()
  expect_error(db_info(sofa_conn, "asdfds"), "Database does not exist")
})
