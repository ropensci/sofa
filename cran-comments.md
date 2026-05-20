## R CMD check results

0 errors | 0 warnings | 2 notes

Checked on Windows 11 x64 with:

* R version 4.4.2 (2024-10-31 ucrt)
* `R CMD check --as-cran --no-manual --no-vignettes`

The two notes are:

* New maintainer:
  Yaoxiang Li <liyaoxiang@outlook.com>
  Old maintainer:
  Scott Chamberlain <myrmecocystus@gmail.com>
* unable to verify current time

The first note is expected for this release. The package is moving from Scott
Chamberlain to Yaoxiang Li as maintainer. Maelle Salmon from rOpenSci has
introduced Yaoxiang Li to Scott Chamberlain by email and copied both parties, so
Scott is aware that a CRAN release is being prepared and that CRAN might need
confirmation from him.

The second note appears to be an environment-specific time verification note on
the local Windows check machine.

## Reverse dependencies

There are no reverse Depends/Imports/LinkingTo dependencies on CRAN.

There is one reverse Suggests dependency on CRAN: nodbi.

## Release summary

This is the first CRAN release of sofa since 0.4.0 in 2020.

Main changes:

* update maintainer and package metadata;
* fix stale documentation URLs;
* add a GitHub Actions R-check workflow;
* make tests independent of IBM Cloudant or a local CouchDB server by default;
* expand test coverage;
* fix `db_replicate()` target URL construction for generic CouchDB-compatible
  servers;
* fix `db_alldocs(..., disk=)` to return the output file path as documented;
* verify documented examples against the mocked CouchDB test service.
