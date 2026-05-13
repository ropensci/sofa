context("server API")

test_that("server endpoints return CouchDB-shaped responses", {
  skip_if_no_couchdb()

  expect_match(ping(sofa_conn, as = "json"), "Welcome")

  tasks <- active_tasks(sofa_conn)
  expect_is(tasks, "list")

  members <- membership(sofa_conn)
  expect_named(members, c("all_nodes", "cluster_nodes"))

  sess <- session(sofa_conn)
  expect_true(sess$ok)
  expect_named(sess, c("ok", "userCtx", "info"))

  ids <- uuids(sofa_conn, count = 3)
  expect_named(ids, "uuids")
  expect_equal(length(ids$uuids), 3)

  expect_true(restart(sofa_conn)$ok)
})

test_that("database maintenance and index endpoints work", {
  skip_if_no_couchdb()

  db <- dbname_random()
  db_create(sofa_conn, db)
  on.exit(cleanup_dbs(db), add = TRUE)

  expect_true(db_compact(sofa_conn, db)$ok)

  indexes <- db_index(sofa_conn, db)
  expect_named(indexes, c("total_rows", "indexes"))
  expect_equal(indexes$total_rows, 1L)

  created <- db_index_create(
    sofa_conn, db,
    body = list(index = list(fields = I("foo")), name = "foo-index", type = "json")
  )
  expect_named(created, c("result", "id", "name"))

  indexes <- db_index(sofa_conn, db)
  expect_equal(indexes$total_rows, 2L)

  deleted <- db_index_delete(sofa_conn, db, indexes$indexes[[2]]$ddoc, indexes$indexes[[2]]$name)
  expect_true(deleted$ok)
})

test_that("replication endpoint posts a CouchDB replication request", {
  skip_if_no_couchdb()

  db <- dbname_random()
  db_create(sofa_conn, db)
  on.exit(cleanup_dbs(db), add = TRUE)

  remote <- Cushion$new(host = "example", port = NULL, transport = "https", user = "user", pwd = "pwd")
  expect_message(res <- db_replicate(sofa_conn, remote, db), "Uploading")
  expect_true(res$ok)
  expect_equal(res$source, db)
  expect_equal(res$target, paste0("https://user:pwd@example/", db))
})

test_that("replication can create the target database first", {
  skip_if_no_couchdb()

  db <- dbname_random()
  on.exit(cleanup_dbs(db), add = TRUE)

  remote <- Cushion$new(host = "example", port = NULL, transport = "https", user = "user", pwd = "pwd")
  expect_message(res <- db_replicate(sofa_conn, remote, db, createdb = TRUE), "Uploading")
  expect_true(res$ok)
  expect_true(db %in% db_list(sofa_conn))
})
