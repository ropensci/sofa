context("internal helpers")

test_that("remote URL helpers build supported service URLs", {
  x <- structure(list(type = "cloudant", user = "alice", pwd = "secret"), class = "Cushion")
  expect_equal(sofa:::remote_url(x, endpt = "_all_dbs"), "https://alice:secret@alice.cloudant.com/_all_dbs")
  expect_equal(sofa:::remote_url(x, dbname = "db"), "https://alice:secret@alice.cloudant.com/db")
  expect_equal(sofa:::remote_url(x, dbname = "db", endpt = "_changes"), "https://alice:secret@alice.cloudant.com/db/_changes")

  x$type <- "iriscouch"
  expect_equal(sofa:::remote_url(x, endpt = "_all_dbs"), "https://alice.iriscouch.com/_all_dbs")
  expect_equal(sofa:::remote_url(x, dbname = "db"), "https://alice.iriscouch.com/db")
  expect_equal(sofa:::remote_url(x, dbname = "db", endpt = "_changes"), "https://alice.iriscouch.com/db/_changes")

  y <- Cushion$new(host = "example.org", port = NULL, transport = "https")
  expect_equal(sofa:::replication_url(y, "db"), "https://example.org/db")

  z <- Cushion$new(host = "example.org", port = NULL, transport = "https", user = "a user", pwd = "p/word")
  expect_equal(sofa:::replication_url(z, "db"), "https://a%20user:p%2Fword@example.org/db")
})

test_that("input helpers cover empty, XML, list, and invalid types", {
  expect_null(sofa:::asl(NULL))
  expect_equal(sofa:::asl(TRUE), "true")
  expect_equal(sofa:::asl(FALSE), "false")

  expect_null(sofa:::check_inputs(NULL))
  expect_match(sofa:::check_inputs("<top><a /></top>"), '"xml"')
  expect_match(sofa:::check_inputs(list(a = 1)), '"a":1')
  expect_error(sofa:::check_inputs(1), "Only character and list")
})

test_that("stop_status delegates empty error responses to crul", {
  res <- crul::HttpResponse$new(
    method = "get",
    url = "http://sofa.test/missing",
    opts = list(),
    handle = NULL,
    status_code = 404L,
    request_headers = list(),
    response_headers = list(),
    response_headers_all = list(),
    modified = Sys.time(),
    times = numeric(),
    content = raw(),
    request = list()
  )

  expect_error(sofa:::stop_status(res), "Not Found|not found|404")
})
