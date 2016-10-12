sofa
====



<pre>
  _ _ _ _ _ _ _ _ _ _ _
 /|                   |\
/ |_ _ _ _ _ _ _ _ _ _| \
\ /                    \/
 \ ___________________ /
</pre>

[![Build Status](https://travis-ci.org/ropensci/sofa.svg?branch=master)](https://travis-ci.org/ropensci/sofa)
[![codecov.io](https://codecov.io/github/ropensci/sofa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/sofa?branch=master)

__An easy interface to CouchDB from R__

Note: Check out [*R4couchdb*](https://github.com/wactbprot/R4CouchDB), another R 
package to interact with CouchDB.

## CouchDB versions

`sofa` is built targeting CouchDB v2 or greater.

## Install CouchDB

Go to <http://docs.couchdb.org/en/2.0.0/install/index.html> for instructions.

## Connect to CouchDB

This may be starting it on your terminal/shell

```sh
couchdb
```

Or opening the CouchDB app on your machine, or running it in docker. Whatever it
is, start it up.

You can interact with your CouchDB databases as well in your browser. Navigate to [http://localhost:5984/_utils](http://localhost:5984/_utils)

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
* `transport`: `http` or `https`
* `port`: The port to connect to. Default: 5984. For Cloudant, have to set to `NULL`
* `user`: User name for the service.
* `pwd`: Password for the service, if any.

If you call `Cushion$new()` with no arguments you get a cushion set up for local 
use on your machine, with all defaults used. 


```r
x <- Cushion$new()
```

## Ping the server


```r
ping(x)
#> $couchdb
#> [1] "Welcome"
#> 
#> $version
#> [1] "2.0.0"
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
#>  [1] "acouch"          "alm_couchdb"     "aqijhfcntb"     
#>  [4] "auhgmimrls"      "avarpnvaia"      "bhlhhiwwph"     
#>  [7] "bulktest"        "bvuizcrdoy"      "cats"           
#> [10] "dpufyoigqf"      "drinksdb"        "fiadbzwmos"     
#> [13] "flxsqfkzdf"      "gtogmgbsjx"      "helloworld"     
#> [16] "jebvagbrqz"      "jxdktgmdsb"      "leothelion"     
#> [19] "leothelion-json" "lgzzmzugkm"      "lhkfptkfel"     
#> [22] "lyluootgvi"      "namcicfbjl"      "nqidfcpojk"     
#> [25] "omdb"            "sofadb"          "spyrzxffqv"     
#> [28] "sss"             "testing123"      "trkhxkopvd"     
#> [31] "uwvtpnehdu"      "vswtlxhcxe"      "wqefduwgpu"     
#> [34] "xhalvmxmud"      "xwrcjghvxx"      "zocaqeleye"
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
#> [1] "e6bb43092edaf8fd987434b8a30d08bd"
#> 
#> $rev
#> [1] "1-fd0da7fcb8d3afbfc5757d065c92362c"
```

### XML?

Write an xml document WITH a name (uses PUT). The xml is written as xml in couchdb, just wrapped in json, when you get it out it will be as xml.

write the xml


```r
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
doc_create(x, doc3, dbname = "sofadb", docid = "somexml")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "somexml"
#> 
#> $rev
#> [1] "1-5f06e82103a0d5baa9d5f75226c8dcb8"
```

get the doc back out


```r
doc_get(x, dbname = "sofadb", docid = "somexml")
#> $`_id`
#> [1] "somexml"
#> 
#> $`_rev`
#> [1] "1-5f06e82103a0d5baa9d5f75226c8dcb8"
#> 
#> $xml
#> [1] "<top><a/><b/><c><d/><e>bob</e></c></top>"
```

get just the xml out


```r
doc_get(x, dbname = "sofadb", docid = "somexml")[["xml"]]
#> [1] "<top><a/><b/><c><d/><e>bob</e></c></top>"
```

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/sofa/issues).
* License: MIT
* Get citation information for `sofa` in R doing `citation(package = 'sofa')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
