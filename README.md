sofa
====



<pre>
  _ _ _ _ _ _ _ _ _ _ _
 /|                   |\
/ |_ _ _ _ _ _ _ _ _ _| \
\ /                    \/
 \ ___________________ /
</pre>

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![cran checks](https://cranchecks.info/badges/worst/sofa)](https://cranchecks.info/pkgs/sofa)
[![Build Status](https://travis-ci.org/ropensci/sofa.svg?branch=master)](https://travis-ci.org/ropensci/sofa)
[![codecov.io](https://codecov.io/github/ropensci/sofa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/sofa?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/sofa?color=ff69b4)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/sofa)](https://cran.r-project.org/package=sofa)

__An easy interface to CouchDB from R__

Note: Check out [*R4couchdb*](https://github.com/wactbprot/R4CouchDB), another R
package to interact with CouchDB.

## CouchDB versions

`sofa` is built targeting CouchDB v2 or greater.

## CouchDB Info

* Docs: <http://docs.couchdb.org/en/latest/index.html>
* Installation: <http://docs.couchdb.org/en/latest/install/index.html>

## Connect to CouchDB

This may be starting it on your terminal/shell

```sh
couchdb
```

Or opening the CouchDB app on your machine, or running it in Docker. Whatever it
is, start it up.

You can interact with your CouchDB databases as well in your browser. Navigate to http://localhost:5984/_utils

## Install sofa

From CRAN


```r
install.packages("sofa")
```

Development version from GitHub


```r
devtools::install_github("ropensci/sofa")
```


```r
library('sofa')
```

## Cushions

Cushions? What? Since it's couch we gotta use `cushions` somehow. `cushions` are a
connection class containing all connection info to a CouchDB instance.
See `?Cushion` for help.

As an example, connecting to a Cloudant couch:


```r
z <- Cushion$new(
  host = "stuff.cloudant.com",
  transport = 'https',
  port = NULL,
  user = 'foobar',
  pwd = 'things'
)
```

Break down of parameters:

* `host`: the base url, without the transport (`http`/`https`)
* `path`: context path that is appended to the end of the url
* `transport`: `http` or `https`
* `port`: The port to connect to. Default: 5984. For Cloudant, have to set to `NULL`
* `user`: User name for the service.
* `pwd`: Password for the service, if any.
* `headers`: headers to pass in all requests

If you call `Cushion$new()` with no arguments you get a cushion set up for local
use on your machine, with all defaults used.


```r
x <- Cushion$new()
```

## Ping the server


```r
x$ping()
#> $couchdb
#> [1] "Welcome"
#> 
#> $version
#> [1] "2.1.1"
#> 
#> $features
#> $features[[1]]
#> [1] "scheduler"
#> 
#> 
#> $vendor
#> $vendor$name
#> [1] "The Apache Software Foundation"
```

Nice, it's working.

## Create a new database, and list available databases


```
#> $ok
#> [1] TRUE
```


```r
db_create(x, dbname = 'sofadb')
#> $ok
#> [1] TRUE
```

see if its there now


```r
db_list(x)
#> [1] "cats"       "flights"    "sofadb"     "testing123"
```

## Create documents

### Write a document WITH a name (uses PUT)


```r
doc1 <- '{"name":"sofa","beer":"IPA"}'
doc_create(x, doc1, dbname = "sofadb", docid = "a_beer")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "a_beer"
#> 
#> $rev
#> [1] "1-a48c98c945bcc05d482bc6f938c89882"
```

### Write a json document WITHOUT a name (uses POST)


```r
doc2 <- '{"name":"sofa","icecream":"rocky road"}'
doc_create(x, doc2, dbname = "sofadb")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "901e4bf214fb50db456d3ef8ec0516c9"
#> 
#> $rev
#> [1] "1-fd0da7fcb8d3afbfc5757d065c92362c"
```

## More docs

See the [vignettes](https://github.com/ropensci/sofa/tree/master/vignettes) for more documentation.


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/sofa/issues).
* License: MIT
* Get citation information for `sofa` in R doing `citation(package = 'sofa')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
