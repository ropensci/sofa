context("doc_delete")

test_that("doc_delete removes an existing document", {
  skip_if_no_couchdb()

  db <- dbname_random()
  db_create(sofa_conn, db)
  on.exit(cleanup_dbs(db), add = TRUE)

  doc_create(sofa_conn, db, '{"name":"drink"}', docid = "a1")
  deleted <- doc_delete(sofa_conn, db, "a1")

  expect_named(deleted, c("ok", "id", "rev"))
  expect_true(deleted$ok)
  expect_equal(deleted$id, "a1")
  expect_error(doc_get(sofa_conn, db, "a1"), "missing")
})
