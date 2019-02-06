context("doc_upsert")

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

test_that("doc_upsert - basic usage works", {
  skip_on_cran()

  aa <- doc_upsert(sofa_conn, db, doc = doc1, docid = "a1")

  expect_is(aa, "list")
  expect_named(aa, c('ok', 'id', 'rev'))
  expect_true(aa$ok)
  expect_is(aa$id, "character")
  expect_is(aa$rev, "character")

  expect_equal(aa$id, "a1")
})



test_that("doc_upsert - creating document works", {
  skip_on_cran()

  aa <- doc_upsert(sofa_conn, db, doc = doc2, docid = "a2")

  expect_is(aa, "list")
  expect_named(aa, c('ok', 'id', 'rev'))
  expect_true(aa$ok)
  expect_is(aa$id, "character")
  expect_is(aa$rev, "character")

  expect_equal(aa$id, "a2")


  doc2_fromJSON = jsonlite::fromJSON(doc2)
  doc2_get = doc_get(sofa_conn, db = "sofadb", docid = "a2")

  expect_equal(doc2_fromJSON$name, doc2_get$name)
  expect_equal(doc2_fromJSON$beer, doc2_get$beer)
  expect_equal(doc2_fromJSON$score, doc2_get$score)
})


test_that("doc_upsert - updating document works", {
  skip_on_cran()

  aa <- doc_upsert(sofa_conn, db, doc = doc3, docid = "a2")

  expect_is(aa, "list")
  expect_named(aa, c('ok', 'id', 'rev'))
  expect_true(aa$ok)
  expect_is(aa$id, "character")
  expect_is(aa$rev, "character")

  expect_equal(aa$id, "a2")


  doc3_fromJSON = jsonlite::fromJSON(doc3)
  doc3_get = doc_get(sofa_conn, db = "sofadb", docid = "a2")

  expect_equal(doc3_fromJSON$name, doc3_get$name)
  expect_equal(doc3_fromJSON$beer, doc3_get$beer)
  expect_equal(doc3_fromJSON$score, doc3_get$score)
})


test_that("doc_upsert fails well", {
  expect_error(doc_upsert(), "argument \"cushion\" is missing")
  expect_error(doc_upsert(sofa_conn), "argument \"doc\" is missing")
})

cleanup_dbs(db)
