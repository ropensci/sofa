# sofa <img src="man/figures/logo.png" width=120px align="right" />

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/sofa)](https://CRAN.R-project.org/package=sofa)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-check](https://github.com/ropensci/sofa/workflows/R-check/badge.svg)](https://github.com/ropensci/sofa/actions)
[![codecov.io](https://codecov.io/github/ropensci/sofa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/sofa?branch=master)
[![rstudio mirror
downloads](https://cranlogs.r-pkg.org/badges/sofa?color=ff69b4)](https://github.com/metacran/cranlogs.app)
<!-- badges: end -->

**An easy interface to CouchDB from R**

Note: Check out [*R4couchdb*](https://github.com/wactbprot/R4CouchDB),
another R package to interact with CouchDB.

sofa docs: <https://docs.ropensci.org/sofa/>

## CouchDB versions

`sofa` works with CouchDB v2 and v3. See [the
builds](https://github.com/ropensci/sofa/actions?query=workflow%3AR-check)
for checks on various CouchDB versions.

## CouchDB Info

-   Docs: <http://docs.couchdb.org/en/latest/index.html>
-   Installation: <http://docs.couchdb.org/en/latest/install/index.html>

## Connect to CouchDB

This may be starting it on your terminal/shell

    couchdb

Or opening the CouchDB app on your machine, or running it in Docker.
Whatever it is, start it up.

## Install sofa

From CRAN

    install.packages("sofa")

Development version from GitHub

    remotes::install_github("ropensci/sofa")

    library('sofa')

## Cushions

Cushions? What? Since it’s couch we gotta use `cushions` somehow.
`cushions` are a connection class containing all connection info to a
CouchDB instance. See `?Cushion` for help.

As an example, connecting to a Cloudant couch:

    z <- Cushion$new(
      host = "stuff.cloudant.com",
      transport = 'https',
      port = NULL,
      user = 'foobar',
      pwd = 'things'
    )

Break down of parameters:

-   `host`: the base url, without the transport (`http`/`https`)
-   `path`: context path that is appended to the end of the url
-   `transport`: `http` or `https`
-   `port`: The port to connect to. Default: 5984. For Cloudant, have to
    set to `NULL`
-   `user`: User name for the service.
-   `pwd`: Password for the service, if any.
-   `headers`: headers to pass in all requests

If you call `Cushion$new()` with no arguments you get a cushion set up
for local use on your machine, with all defaults used.

    x <- Cushion$new()

Ping the server

    x$ping()

Nice, it’s working.

## More

See the docs <https://docs.ropensci.org/sofa/> for more.

## Meta

-   Please [report any issues or
    bugs](https://github.com/ropensci/sofa/issues).
-   License: MIT
-   Get citation information for `sofa` in R doing
    `citation(package = 'sofa')`
-   Please note that this project is released with a [Contributor Code
    of
    Conduct](https://github.com/ropensci/sofa/blob/master/CODE_OF_CONDUCT.md).
    By participating in this project you agree to abide by its terms.

[![ropensci\_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
