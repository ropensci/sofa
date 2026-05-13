context("revisions")

test_that("db_revisions can return detailed revision info and json", {
  skip_if_no_couchdb()

  db <- dbname_random()
  db_create(sofa_conn, db)
  on.exit(cleanup_dbs(db), add = TRUE)

  doc_create(sofa_conn, db, '{"name":"drink"}', docid = "a1")

  detailed <- db_revisions(sofa_conn, db, "a1", simplify = FALSE)
  expect_is(detailed, "list")
  expect_named(detailed[[1]], c("rev", "status"))

  json <- db_revisions(sofa_conn, db, "a1", as = "json")
  expect_is(json, "json")
})
