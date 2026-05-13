context("attachments")

test_that("attachments can be created, inspected, read, and deleted", {
  skip_if_no_couchdb()

  db <- dbname_random()
  db_create(sofa_conn, db)
  on.exit(cleanup_dbs(db), add = TRUE)

  doc_create(sofa_conn, db, '{"name":"drink"}', docid = "a1")

  path <- tempfile(fileext = ".txt")
  writeLines("hello couch", path)

  created <- doc_attach_create(sofa_conn, db, "a1", path, "hello.txt")
  expect_true(created$ok)

  info <- doc_attach_info(sofa_conn, db, "a1", "hello.txt")
  expect_true("rev" %in% names(info))

  txt <- doc_attach_get(sofa_conn, db, "a1", "hello.txt", type = "text")
  expect_match(txt, "hello couch")

  raw <- doc_attach_get(sofa_conn, db, "a1", "hello.txt")
  expect_type(raw, "raw")

  listing <- doc_attach_get(sofa_conn, db, "a1", type = "text")
  expect_match(listing, "_attachments")

  deleted <- doc_attach_delete(sofa_conn, db, "a1", "hello.txt")
  expect_true(deleted$ok)

  doc_create(sofa_conn, db, '{"name":"water"}', docid = "a2")
  created_json <- doc_attach_create(sofa_conn, db, "a2", path, "hello.txt", as = "json")
  expect_is(created_json, "character")
  expect_match(created_json, '"ok":true')
})

test_that("attachment creation checks input file existence", {
  skip_if_no_couchdb()

  expect_error(
    doc_attach_create(sofa_conn, db_test_name, "missing", tempfile(), "missing.txt"),
    "the file does not exist"
  )
})

test_that("defunct attachment alias reports replacement", {
  expect_error(attach_get(), "doc_attach_get")
})
