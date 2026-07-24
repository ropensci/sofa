sofa 0.4.2
==========

### BUG FIXES

* Fixed Rd markup for the CouchDB `GET /{db}` reference in `db_compact()`
  (lost braces note on CRAN checks; request from Kurt Hornik, 2026-07-20).
* Replaced deprecated `structure(..., .Names = )` with `names =` in design
  search examples and tests.
* Corrected Eduard Szöcs's ORCID in DESCRIPTION (was accidentally duplicated
  from Scott Chamberlain).

sofa 0.4.1
==========

### MINOR IMPROVEMENTS

* Updated package metadata and documentation links for CRAN.
* Added a GitHub Actions check workflow for Linux, macOS, and Windows.
* Reworked tests to use a lightweight mocked CouchDB service by default, while
  preserving the option to test against a real CouchDB server with
  `SOFA_TEST_REAL_COUCHDB=true`.
* Expanded test coverage across the package.

### BUG FIXES

* Fixed `db_replicate()` so replication targets use the supplied remote
  `Cushion` URL rather than assuming the old Cloudant URL pattern.
* Fixed `db_alldocs(..., disk=)` to return the output file path as documented.
* Fixed stale examples and verified documented examples against the mocked
  CouchDB test service.
* Declared the `cli` test dependency used by `testthat`.

sofa 0.4.0
==========

### NEW FEATURES

* new function `doc_upsert()`: updates an existing document or creates it if it doesn't yet exist (#69) work by @critichu

CouchDB v3 related changes

* made sure sofa works with v3; all examples/tests updated to use username/password  (#73)
* new function `db_bulk_get()` for the `/{db}/_bulk_get` route  (#73)
* fixed `design_search_many()`: in couch v2.2 and greater there's a new route `/{db}/_design/{ddoc}/_view/{view}/queries`, which is used in this fxn now instead of using the `/{db}/_design/{ddoc}/_view/{view}` route (#75)
* Cushion class gains new method `$version()` to get the CouchDB version you're using as a numeric (to enable progammatic couch version checking)
* `db_query()` changes: some new parameters added: `r`, `bookmark`, `update`, `stable`, `stale`, and `execution_stats` (#74)

### DEFUNCT

* `attach_get()` is now defunct, use `doc_attach_get()` (#76)

### MINOR IMPROVEMENTS

* added more tests (#61)
* `design_search()` now allows more possible values for start and end keys: `startkey_docid`, `start_key_doc_id`, `startkey`, `start_key`, `endkey_docid`, `end_key_doc_id`, `endkey`, `end_key` (#62)
* add title to vignettes (#71)
* for `docs_create()` internally support using user's setting for the R option `digits` to pass on to `jsonlite::toJSON` to control number of digits after decimal place (#66)

### BUG FIXES

* fixed authorization problems in `$ping()` method in Cushion; now separate `ping()` function calls `$ping()` method in Cushion (#72)

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
