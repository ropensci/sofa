context("design")

test_that("design documents can be read, inspected, and deleted", {
  skip_if_no_couchdb()

  db <- dbname_random()
  db_create(sofa_conn, db)
  on.exit(cleanup_dbs(db), add = TRUE)

  created <- design_create(sofa_conn, db, design = "view-doc", fxnname = "by_country", value = "doc.Country")
  expect_true(created$ok)

  got <- design_get(sofa_conn, db, "view-doc")
  expect_equal(got$`_id`, "_design/view-doc")
  expect_named(got$views, "by_country")

  head <- design_head(sofa_conn, db, "view-doc")
  expect_true("rev" %in% names(head))

  info <- design_info(sofa_conn, db, "view-doc")
  expect_named(info, c("name", "view_index"))

  deleted <- design_delete(sofa_conn, db, "view-doc")
  expect_true(deleted$ok)

  expect_error(design_get(sofa_conn, db, "view-doc"), "missing")
})
