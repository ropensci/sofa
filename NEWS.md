sofa 0.3.0
==========

### NEW FEATURES

* Gains new functions `db_index`, `db_index_create`, and `db_index_delete` 
for getting an index, creating one, and deleting one
* Gains function `design_search_many` to do many queries at once 
in a `POST` request (#56)
* `design_search` reworked to allow user to do a `GET` request or 
`POST` request depending on if they use `params` parameter or
`body` parameter - many parameters removed in the function 
definition, and are now to be passed to `params` or `body` (#56)
* `db_alldocs` gains new parameter `disk` to optionally
write data to disk instead of into the R session - should help
when data is very large (if disk is used fxn returns a file path) (#64)

### MINOR IMPROVEMENTS

* fix minor issues in vignette, and updated for working with CouchDB v2 and greater (#53) (#54) (#47)
* replace `httr` with `crul` for HTTP requests (#52)
* `design_copy` removed temporarily (#20) (#60)
* new issue and pull request template

### BUG FIXES

* Fix to docs for `design_search` (#57) thanks @michellymenezes
* Fix to `db_query` to make a single field passed to `fields` parameter
work (#63) thanks @gtumuluri
* Fix error in `doc_attach_get` (#58) thanks @gtumuluri


sofa 0.2.0
==========

### NEW FEATURES

* released to CRAN
