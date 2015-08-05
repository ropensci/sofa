sofa
====



<pre>
  _ _ _ _ _ _ _ _ _ _ _ 
 /|                   |\
/ |_ _ _ _ _ _ _ _ _ _| \
\ /                    \/
 \ ___________________ /
</pre>

[![Build Status](https://travis-ci.org/ropensci/sofa.png?branch=master)](https://travis-ci.org/ropensci/sofa)
[![codecov.io](https://codecov.io/github/ropensci/sofa/coverage.svg?branch=master)](https://codecov.io/github/ropensci/sofa?branch=master)

#### *An easy interface to CouchDB from R*

Note: Check out [*R4couchdb*](https://github.com/wactbprot/R4CouchDB), another R package to interact with CouchDB. 

## Quickstart

### Install CouchDB

Instructions [here](http://wiki.apache.org/couchdb/Installation)

### Connect to CouchDB

In your terminal 

```sh
couchdb
```

You can interact with your CouchDB databases as well in your browser. Navigate to [http://localhost:5984/_utils](http://localhost:5984/_utils)

### Install sofa


```r
devtools::install_github("ropensci/sofa")
```


```r
library('sofa')
```

### Cushions

Cushions? What? Since it's couch we gotta use `cushions` somehow. `cushions` are basically just a simple named list holding details of connections for different couches you work with. See `?cushions` or `?authentication` for help. 

As an example, here's how I set up details for connecting to my Cloudant couch:


```r
cushion(name = 'cloudant', user = '<user name>', pwd = '<password>', type = "cloudant")
```

Break down of parameters: 

* `name`: Name of the cushion. This is how you'll refer to each connection. `cushion` is the first parameter of each function. 
* `user`: User name for the service.
* `pwd`: Password for the service, if any.
* `type`: Type of cushion. This is important. Only `localhost`, `cloudant`, and `iriscouch` are supported right now. Internally in `sofa` functions this variable determines how urls are constructed for http requests. 
* `port`: The port to connect to. Default: 5984

Of course by default there is a built in `cushion` for localhost so you don't have to do that, unless you want to change those details, e.g., the port number.

You can preserve cushions across sessions by storing them in a hidden file. See `?authentication` for details.

### Ping the server


```r
ping()
#> $couchdb
#> [1] "Welcome"
#> 
#> $uuid
#> [1] "2c10f0c6d9bd17205b692ae93cd4cf1d"
#> 
#> $version
#> [1] "1.6.1"
#> 
#> $vendor
#> $vendor$version
#> [1] "1.6.1-1"
#> 
#> $vendor$name
#> [1] "Homebrew"
```

Nice, it's working.

### Create a new database, and list available databases


```
#> $ok
#> [1] TRUE
```


```r
db_create(dbname='sofadb')
#> $ok
#> [1] TRUE
```

see if its there now


```r
db_list()
#>  [1] "_replicator"  "_users"       "adsfa"        "bulkfromchr" 
#>  [5] "bulkfromlist" "bulktest"     "bulktest2"    "bulktest3"   
#>  [9] "bulktest4"    "bulktest5"    "cachecall"    "diamonds"    
#> [13] "hello_earth"  "iris"         "iriscolumns"  "irisrows"    
#> [17] "leothelion"   "leothelion2"  "mapuris"      "mran"        
#> [21] "mtcarsdb"     "mydb"         "newdbs"       "newnew"      
#> [25] "sofadb"       "stuff"        "stuff2"       "test"
```

### Create documents

#### Write a document WITH a name (uses PUT)


```r
doc1 <- '{"name":"sofa","beer":"IPA"}'
doc_create(doc1, dbname="sofadb", docid="a_beer")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "a_beer"
#> 
#> $rev
#> [1] "1-a48c98c945bcc05d482bc6f938c89882"
```

#### Write a json document WITHOUT a name (uses POST)


```r
doc2 <- '{"name":"sofa","icecream":"rocky road"}'
doc_create(doc2, dbname="sofadb")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "5ec47bcb445304091a7fde125f0003d1"
#> 
#> $rev
#> [1] "1-fd0da7fcb8d3afbfc5757d065c92362c"
```

#### XML? 

Write an xml document WITH a name (uses PUT). The xml is written as xml in couchdb, just wrapped in json, when you get it out it will be as xml.

write the xml


```r
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
doc_create(doc3, dbname="sofadb", docid="somexml")
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
doc_get(dbname="sofadb", docid="somexml")
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
doc_get(dbname="sofadb", docid="somexml")[["xml"]]
#> [1] "<top><a/><b/><c><d/><e>bob</e></c></top>"
```

### Views

__Still working on these functions, check back later...__

## Meta

* Please [report any issues or bugs](https://github.com/ropensci/sofa/issues).
* License: MIT
* Get citation information for `sofa` in R doing `citation(package = 'sofa')`

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
