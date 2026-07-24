## R CMD check results

0 errors | 0 warnings | 1 note

Checked on Windows 11 x64 with:

* R version 4.6.0 (2026-04-24 ucrt)
* `R CMD check --as-cran --no-manual --no-vignettes`

The note is:

* New maintainer:
  Yaoxiang Li <liyaoxiang@outlook.com>
  Old maintainer:
  Scott Chamberlain <myrmecocystus@gmail.com>

This note is expected for this release. The package is moving from Scott
Chamberlain to Yaoxiang Li as maintainer. Maelle Salmon from rOpenSci has
introduced Yaoxiang Li to Scott Chamberlain by email and copied both parties, so
Scott is aware that a CRAN release is being prepared and that CRAN might need
confirmation from him.

## Response to CRAN (Kurt Hornik, 2026-07-20)

This submission (0.4.2) addresses the CRAN check notes on sofa 0.4.0:

* Rd files: escaped braces in the `GET /{db}` reference in `db_compact()` docs.
* R code for possible problems: replaced deprecated `structure(..., .Names = )`
  with `names =` in design search tests/examples.

## Reverse dependencies

There are no reverse Depends/Imports/LinkingTo dependencies on CRAN.

There is one reverse Suggests dependency on CRAN: nodbi.

## Release summary

This is a patch release in response to the CRAN email of 2026-07-20.

Main changes since 0.4.0:

* update maintainer and package metadata;
* fix stale documentation URLs;
* add a GitHub Actions R-check workflow;
* make tests independent of IBM Cloudant or a local CouchDB server by default;
* expand test coverage;
* fix `db_replicate()` target URL construction for generic CouchDB-compatible
  servers;
* fix `db_alldocs(..., disk=)` to return the output file path as documented;
* fix Rd lost-braces markup and deprecated `.Names` usage flagged on CRAN;
* correct a duplicated ORCID in Authors@R;
* verify documented examples against the mocked CouchDB test service.
