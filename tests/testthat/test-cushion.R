context("Cushion")

test_that("Cushion stores connection pieces and prints without exposing passwords", {
  x <- Cushion$new(
    host = "example.org",
    port = NULL,
    path = "couch",
    transport = "https",
    user = "alice",
    pwd = "secret",
    headers = list(`X-Test` = "yes")
  )

  expect_equal(x$make_url(), "https://example.org/couch")
  expect_equal(x$get_headers(), list(`X-Test` = "yes"))
  expect_is(x$get_auth(), "auth")

  y <- Cushion$new(host = "example.org", port = 5984)
  expect_equal(y$make_url(), "http://example.org:5984")

  printed <- capture.output(print(x))
  expect_true(any(grepl("https", printed)))
  expect_true(any(grepl("<secret>", printed)))
  expect_false(any(grepl("secret$", printed)))
})

test_that("Cushion version pads short CouchDB versions", {
  skip_if_no_couchdb()

  expect_equal(sofa_conn$version(), 333)

  old_ping <- sofa_conn$ping
  unlockBinding("ping", sofa_conn)
  sofa_conn$ping <- function(...) list(version = "3")
  on.exit({
    sofa_conn$ping <- old_ping
    lockBinding("ping", sofa_conn)
  })

  expect_equal(sofa_conn$version(), 300)
})
