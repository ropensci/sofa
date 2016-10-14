context("db_bulk_update")

just_dat <- function(x) {
  do.call("rbind.data.frame", lapply(x$rows, function(z) {
    docs <- z$doc
    docs[!names(docs) %in% c('_id', '_rev')]
  }))
}

test_that("db_bulk_update basic usage works", {
  skip_on_cran()

  row.names(mtcars) <- NULL

  if ("bulktest" %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname="bulktest"))
  }
  invisible(db_create(sofa_conn, dbname="bulktest"))
  aa <- db_bulk_create(sofa_conn, mtcars, dbname="bulktest")
  aa_data <- just_dat(db_alldocs(sofa_conn, dbname = "bulktest", include_docs = TRUE))

  # modify mtcars
  mtcars$letter <- sample(letters, NROW(mtcars), replace = TRUE)
  bb <- db_bulk_update(sofa_conn, "bulktest", mtcars)
  bb_data <- just_dat(db_alldocs(sofa_conn, dbname = "bulktest", include_docs = TRUE))

  # change again
  mtcars$num <- 89
  cc <- db_bulk_update(sofa_conn, "bulktest", mtcars)
  cc_data <- just_dat(db_alldocs(sofa_conn, dbname = "bulktest", include_docs = TRUE))

	expect_is(aa, "list")
	expect_is(bb, "list")
	expect_is(cc, "list")

	expect_equal(length(aa), 32)
	expect_equal(length(bb), 32)
	expect_equal(length(cc), 32)

	expect_is(aa_data, "data.frame")
	expect_is(bb_data, "data.frame")
	expect_is(cc_data, "data.frame")

	expect_false("letter" %in% names(aa_data))
	expect_true("letter" %in% names(bb_data))
	expect_false("num" %in% names(bb_data))
	expect_true("letter" %in% names(cc_data))
	expect_true("num" %in% names(cc_data))

	cleanup_dbs("bulktest")
})

test_that("db_bulk_update fails well", {
  expect_error(db_bulk_update(), "argument \"cushion\" is missing")
  expect_error(db_bulk_update(sofa_conn), "argument \"doc\" is missing")
  expect_error(db_bulk_update(sofa_conn, "stuff"), "argument \"doc\" is missing")

  skip_on_cran()
  expect_error(db_bulk_update(sofa_conn, "asdfds", mtcars), "Database does not exist")
  expect_error(db_bulk_update(sofa_conn, "asdfds", 5),
               "No 'db_bulk_update' method for class numeric")
})
