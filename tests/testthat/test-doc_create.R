context("doc_create")

db <- dbname_random()

local({
  skip_on_cran()
  if (db %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname = db))
  }
  invisible(db_create(sofa_conn, dbname = db))
})

doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
doc2 <- '{"name": "drink", "beer": "pale ale", "score": 6}'
doc3 <- '{"name": "drink", "beer": "barleywine", "score": 9}'

test_that("doc_create - basic usage works - with id", {
  skip_on_cran()

  aa <- doc_create(sofa_conn, db, doc = doc1, docid = "a1")

	expect_is(aa, "list")
	expect_named(aa, c('ok', 'id', 'rev'))
  expect_true(aa$ok)
  expect_is(aa$id, "character")
  expect_is(aa$rev, "character")

  expect_equal(aa$id, "a1")
})

test_that("doc_create - basic usage works - without id", {
  skip_on_cran()

  aa <- doc_create(sofa_conn, db, doc = doc2)

  expect_is(aa, "list")
  expect_named(aa, c('ok', 'id', 'rev'))
  expect_true(aa$ok)
  expect_is(aa$id, "character")
  expect_is(aa$rev, "character")

  expect_false(identical(aa$id, "a1"))
  expect_gt(nchar(aa$id), 20)
})

test_that("doc_create - json back works", {
  skip_on_cran()

  aa <- doc_create(sofa_conn, db, doc = doc3, as = "json")

  expect_is(aa, "character")
  expect_match(aa, "ok")
  expect_match(aa, "true")
  expect_match(aa, "id")
  expect_match(aa, "rev")
  expect_is(jsonlite::fromJSON(aa), "list")
})

test_that("doc_create fails well", {
  expect_error(doc_create(), "argument \"cushion\" is missing")
  expect_error(doc_create(sofa_conn), "argument \"doc\" is missing")
  expect_error(doc_create(sofa_conn, "asdfds", "asdfadf"),
               "invalid char in json text")

  skip_on_cran()
  expect_error(doc_create(sofa_conn, "asdfds", '{"a": 5}'),
               "Database does not exist")
})

cleanup_dbs(db)
