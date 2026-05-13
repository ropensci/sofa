context("doc_create")

db <- dbname_random()

local({
  skip_if_no_couchdb()
  if (db %in% db_list(sofa_conn)) {
    invisible(db_delete(sofa_conn, dbname = db))
  }
  invisible(db_create(sofa_conn, dbname = db))
})

doc1 <- '{"name": "drink", "beer": "IPA", "score": 5}'
doc2 <- '{"name": "drink", "beer": "pale ale", "score": 6}'
doc3 <- '{"name": "drink", "beer": "barleywine", "score": 9}'

test_that("doc_create - basic usage works - with id", {
  skip_if_no_couchdb()

  aa <- doc_create(sofa_conn, db, doc = doc1, docid = "a1")

	expect_is(aa, "list")
	expect_named(aa, c('ok', 'id', 'rev'))
  expect_true(aa$ok)
  expect_is(aa$id, "character")
  expect_is(aa$rev, "character")

  expect_equal(aa$id, "a1")
})

test_that("doc_create - basic usage works - without id", {
  skip_if_no_couchdb()

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
  skip_if_no_couchdb()

  aa <- doc_create(sofa_conn, db, doc = doc3, as = "json")

  expect_is(aa, "character")
  expect_match(aa, "ok")
  expect_match(aa, "true")
  expect_match(aa, "id")
  expect_match(aa, "rev")
  expect_is(jsonlite::fromJSON(aa), "list")

  bb <- doc_create(sofa_conn, db, doc = '{"name":"water"}', docid = "json-id", as = "json")
  expect_is(bb, "character")
  expect_match(bb, '"ok":true')
  expect_equal(jsonlite::fromJSON(bb)$id, "json-id")
})

test_that("doc_create accepts lists and data frames", {
  skip_if_no_couchdb()

  aa <- doc_create(sofa_conn, db, doc = list(name = "drink", score = 10), docid = "list-doc")
  expect_true(aa$ok)
  expect_equal(doc_get(sofa_conn, db, "list-doc")$name, "drink")

  bb <- doc_create(sofa_conn, db, doc = list(name = "food"))
  expect_true(bb$ok)
  expect_equal(doc_get(sofa_conn, db, bb$id)$name, "food")

  cc <- doc_create(sofa_conn, db, doc = data.frame(name = c("a", "b"), score = c(1, 2)))
  expect_equal(length(cc), 2)
  expect_true(all(vapply(cc, "[[", logical(1), "ok")))
})

test_that("doc_create fails well", {
  expect_error(doc_create(), "argument \"cushion\" is missing")
  expect_error(doc_create(sofa_conn), "argument \"doc\" is missing")

  skip_if_no_couchdb()
  expect_error(doc_create(sofa_conn, "asdfds", "asdfadf"),
               "invalid char in json text")
  expect_error(doc_create(sofa_conn, "asdfds", '{"a": 5}'),
               "Database does not exist")
})

cleanup_dbs(db)
