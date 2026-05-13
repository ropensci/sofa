context("parse_df")

test_that("parse_df handles rows and columns as JSON or lists", {
  dat <- data.frame(
    name = factor(c("a", "b")),
    value = c(1, 2),
    stringsAsFactors = TRUE
  )

  rows_json <- parse_df(dat, how = "rows")
  expect_equal(length(rows_json), 2)
  expect_match(rows_json[[1]], '"name":"a"')

  rows_list <- parse_df(dat, how = "rows", tojson = FALSE)
  expect_equal(rows_list[[1]]$name, "a")
  expect_equal(rows_list[[2]]$value, 2)

  cols_json <- parse_df(dat, how = "columns")
  expect_named(cols_json, c("name", "value"))
  expect_match(cols_json$name, '"name"')

  cols_list <- parse_df(dat, how = "columns", tojson = FALSE)
  expect_equal(cols_list$name$name, c("a", "b"))
  expect_equal(cols_list$value$value, c(1, 2))
})

test_that("parse_df validates input type", {
  expect_error(parse_df(list(a = 1)), "dat must be a data.frame")
})
