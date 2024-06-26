#' Parse data.frame to json or list by row or column
#'
#' @export
#' @param dat (data.frame) A data.frame, matrix, or tbl_df
#' @param how (character) One of rows (default) or columns. If rows, each
#' row becomes a separate document; if columns, each column becomes a
#' separate document.
#' @param tojson (logical) If `TRUE` (default) convert to json - if `FALSE`,
#' to lists
#' @param ... Further args passed on to `jsonlite::toJSON()`
#' @details Parse data.frame to get either rows or columns, each as a list
#' or json string
#' @examples \dontrun{
#' parse_df(mtcars, how = "rows")
#' parse_df(mtcars, how = "columns")
#' parse_df(mtcars, how = "rows", tojson = FALSE)
#' parse_df(mtcars, how = "columns", tojson = FALSE)
#' }
parse_df <- function(dat, how = "rows", tojson = TRUE, ...) {
  if (!inherits(dat, "data.frame")) stop("dat must be a data.frame", call. = FALSE)
  how <- match.arg(how, c("rows", "columns"))

  # convert all factor to character
  dat[vapply(dat, is.factor, logical(1))] <-
    lapply(dat[vapply(dat, is.factor, logical(1))], as.character)

  switch(how,
    rows = {
      if (tojson) {
        out <- list()
        for (i in seq_len(NROW(dat))) {
          out[[i]] <- jsonlite::toJSON(as.list(stats::setNames(dat[i, ], names(dat))), auto_unbox = TRUE, ...)
        }
        out
      } else {
        out <- list()
        for (i in seq_len(NROW(dat))) {
          out[[i]] <- as.list(stats::setNames(dat[i, ], names(dat)))
        }
        out
      }
    },
    columns = {
      out <- list()
      for (i in seq_along(dat)) {
        out[[names(dat)[i]]] <- stats::setNames(list(dat[, i]), names(dat)[i])
      }
      if (tojson) {
        lapply(out, jsonlite::toJSON, auto_unbox = TRUE, ...)
      } else {
        out
      }
    }
  )
}
