#' Parse data.frame to json or list by row or column
#'
#' @export
#' @param dat (data.frame) A data.frame, matrix, or tbl_df
#' @param how (character) One of rows (default) or columns. If rows, each row becomes a
#' separate document; if columns, each column becomes a separate document.
#' @param tojson (logical) If \code{TRUE} (default) convert to json - if \code{FALSE}, to lists
#' @param ... Further args passed on to \code{\link[jsonlite]{toJSON}}
#' @details Parse data.frame to get either rows or columns, each as a list or json string
#' @examples \dontrun{
#' parse_df(mtcars, how="rows")
#' parse_df(mtcars, how="columns")
#' parse_df(mtcars, how="rows", tojson=FALSE)
#' parse_df(mtcars, how="columns", tojson=FALSE)
#' }
parse_df <- function(dat, how = "rows", tojson = TRUE, ...) {
  how <- match.arg(how, c('rows','columns'))
  switch(how,
         rows = {
           apply(dat, 1, function(x){
             if(tojson){
               jsonlite::toJSON(as.list(setNames(x, names(dat))), auto_unbox = TRUE, ...)
             } else {
               as.list(setNames(x, names(dat)))
             }
           })
         },
         columns = {
           out <- list()
           for(i in seq_along(dat)){
             out[[ names(dat)[i] ]] <- setNames(list(dat[,i]), names(dat)[i])
           }
           if(tojson){
             lapply(out, jsonlite::toJSON, auto_unbox = TRUE, ...)
           } else {
             out
           }
         }
  )
}
