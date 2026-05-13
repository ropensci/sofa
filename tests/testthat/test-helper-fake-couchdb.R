context("fake CouchDB server")

test_that("fake CouchDB server returns CouchDB-shaped database responses", {
  srv <- start_fake_couchdb()
  on.exit(srv$stop(), add = TRUE)

  con <- srv$cushion()

  expect_match(con$ping()$couchdb, "Welcome")
  expect_equal(db_create(con, "shapecheck"), list(ok = TRUE))
  expect_error(db_create(con, "shapecheck"), "The database could not be created, the file already exists.")

  created <- doc_create(con, "shapecheck", '{"type":"drink"}', docid = "drink1")
  expect_named(created, c("ok", "id", "rev"))
  expect_true(grepl("^1-", created$rev))

  info <- db_info(con, "shapecheck")
  expect_equal(info$db_name, "shapecheck")
  expect_equal(info$doc_count, 1L)

  all_docs <- db_alldocs(con, "shapecheck", include_docs = TRUE)
  expect_named(all_docs, c("total_rows", "offset", "rows"))
  expect_named(all_docs$rows[[1]], c("id", "key", "value", "doc"))
  expect_named(all_docs$rows[[1]]$value, "rev")

  expect_error(db_info(con, "missingdb"), "Database does not exist.")
})
