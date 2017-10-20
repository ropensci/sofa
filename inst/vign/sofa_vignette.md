<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{sofa introduction}
%\VignetteEncoding{UTF-8}
-->



sofa introduction
=========

CouchDB links

+ [Apache CouchDB](http://couchdb.apache.org/)
+ [CouchDB docs](http://docs.couchdb.org/en/2.1.0/index.html)

## CouchDB versions

`sofa` is built targeting CouchDB v2 or greater.

## Install CouchDB

Go to <http://docs.couchdb.org/en/2.1.0/install/index.html> for instructions.

## Start CouchDB

Start CouchDB however is appropriate for your setup. You can interact with your CouchDB databases as well in your browser. Navigate to <http://localhost:5984>

## Install sofa

Stable version


```r
install.packages("sofa")
```

Development version


```r
devtools::install_github("ropensci/sofa")
```

Load library


```r
library(sofa)
```

## sofa package API

The following is a breakdown of the major groups of functions - note that not all are included.

__create a CouchDB client connection__

* `Cushion`

__work with databases__

* `db_alldocs`
* `db_changes`
* `db_compact`
* `db_create`
* `db_delete`
* `db_explain`
* `db_info`
* `db_list`
* `db_query`
* `db_replicate`
* `db_revisions`
* `db_index`
* `db_index_create`
* `db_index_delete`

__work with views/design documents__

* `design_create`
* `design_create_`
* `design_delete`
* `design_get`
* `design_head`
* `design_info`
* `design_search`
* `design_search_many`

__work with documents__

* `doc_create`
* `doc_delete`
* `doc_get`
* `doc_head`
* `doc_update`
* `db_bulk_create`
* `db_bulk_update`
* `doc_attach_create`
* `doc_attach_delete`
* `doc_attach_get`
* `doc_attach_info`

## Create a connection client


```r
(x <- Cushion$new())
#> <sofa - cushion> 
#>   transport: http
#>   host: 127.0.0.1
#>   port: 5984
#>   path: 
#>   type: 
#>   user: 
#>   pwd:
```

## Ping your server


```r
ping(x)
#> $couchdb
#> [1] "Welcome"
#> 
#> $version
#> [1] "2.1.0"
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

## Create a new database




```r
db_create(x, 'cats')
#> $ok
#> [1] TRUE
```

## List databases


```r
db_list(x)
#>  [1] "bulkfromchr" "bulktest2"   "bulktest3"   "cats"        "cchecksdb"  
#>  [6] "drinksdb"    "hello_earth" "iris190"     "iris984"     "irisrows"   
#> [11] "sofadb"      "test"        "testing"     "testing123"  "testiris"
```

## Create a document


```r
doc1 <- '{"name": "leo", "color": "blue", "furry": true, "size": 1}'
doc_create(x, dbname = "cats", doc1, docid = "bluecat")
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "bluecat"
#> 
#> $rev
#> [1] "1-41784f190c466d990684003a958c9f39"
```

and another!


```r
doc2 <- '{"name": "samson", "color": "red", "furry": false, "size": 3}'
doc_create(x, dbname = "cats", doc2)
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "15b4cdf4dfa683352b57015af2cff956"
#> 
#> $rev
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
```

and one more, cause 3's company


```r
doc3 <- '{"name": "matilda", "color": "green", "furry": false, "size": 5, "age": 2}'
doc_create(x, dbname = "cats", doc3)
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "15b4cdf4dfa683352b57015af2cffc00"
#> 
#> $rev
#> [1] "1-953d3cfbbebb977fb75940c2bb0c93a1"
```

Note how we used a document id in the first document creation, but
not in the second and third. Using a document id is optional.

Also note that the third document has an additional field "age".

## Changes feed


```r
db_changes(x, "cats")
#> $results
#> $results[[1]]
#> $results[[1]]$seq
#> [1] "1-g1AAAAB5eJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbmSWaplsaYFNAx5j8liAJEMDkPoPMi2RIQsAvksmfA"
#> 
#> $results[[1]]$id
#> [1] "15b4cdf4dfa683352b57015af2cff956"
#> 
#> $results[[1]]$changes
#> $results[[1]]$changes[[1]]
#> $results[[1]]$changes[[1]]$rev
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
#> 
#> 
#> 
#> 
#> $results[[2]]
#> $results[[2]]$seq
#> [1] "2-g1AAAACbeJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbmSWaplsaYFNAx5j8liAJEMDkPqPYlqKgblZqlEqNn1ZAGmlMK8"
#> 
#> $results[[2]]$id
#> [1] "bluecat"
#> 
#> $results[[2]]$changes
#> $results[[2]]$changes[[1]]
#> $results[[2]]$changes[[1]]$rev
#> [1] "1-41784f190c466d990684003a958c9f39"
#> 
#> 
#> 
#> 
#> $results[[3]]
#> $results[[3]]$seq
#> [1] "3-g1AAAACbeJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbmSWaplsaYFNAx5j8liAJEMDkPoPNY0JbFqKgblZqlEqNn1ZAGnHMLA"
#> 
#> $results[[3]]$id
#> [1] "15b4cdf4dfa683352b57015af2cffc00"
#> 
#> $results[[3]]$changes
#> $results[[3]]$changes[[1]]
#> $results[[3]]$changes[[1]]$rev
#> [1] "1-953d3cfbbebb977fb75940c2bb0c93a1"
#> 
#> 
#> 
#> 
#> 
#> $last_seq
#> [1] "3-g1AAAACbeJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbmSWaplsaYFNAx5j8liAJEMDkPoPNY0JbFqKgblZqlEqNn1ZAGnHMLA"
#> 
#> $pending
#> [1] 0
```

## Search

The simplest search just returns the documents.


```r
db_query(x, dbname = "cats", selector = list(`_id` = list(`$gt` = NULL)))$docs
#> [[1]]
#> [[1]]$`_id`
#> [1] "15b4cdf4dfa683352b57015af2cff956"
#> 
#> [[1]]$`_rev`
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
#> 
#> [[1]]$name
#> [1] "samson"
#> 
#> [[1]]$color
#> [1] "red"
#> 
#> [[1]]$furry
#> [1] FALSE
#> 
#> [[1]]$size
#> [1] 3
#> 
#> 
#> [[2]]
#> [[2]]$`_id`
#> [1] "15b4cdf4dfa683352b57015af2cffc00"
#> 
#> [[2]]$`_rev`
#> [1] "1-953d3cfbbebb977fb75940c2bb0c93a1"
#> 
#> [[2]]$name
#> [1] "matilda"
#> 
#> [[2]]$color
#> [1] "green"
#> 
#> [[2]]$furry
#> [1] FALSE
#> 
#> [[2]]$size
#> [1] 5
#> 
#> [[2]]$age
#> [1] 2
#> 
#> 
#> [[3]]
#> [[3]]$`_id`
#> [1] "bluecat"
#> 
#> [[3]]$`_rev`
#> [1] "1-41784f190c466d990684003a958c9f39"
#> 
#> [[3]]$name
#> [1] "leo"
#> 
#> [[3]]$color
#> [1] "blue"
#> 
#> [[3]]$furry
#> [1] TRUE
#> 
#> [[3]]$size
#> [1] 1
```

Search for cats that are red


```r
db_query(x, dbname = "cats", selector = list(color = "red"))$docs
#> [[1]]
#> [[1]]$`_id`
#> [1] "15b4cdf4dfa683352b57015af2cff956"
#> 
#> [[1]]$`_rev`
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
#> 
#> [[1]]$name
#> [1] "samson"
#> 
#> [[1]]$color
#> [1] "red"
#> 
#> [[1]]$furry
#> [1] FALSE
#> 
#> [[1]]$size
#> [1] 3
```

Search for cats that are furry


```r
db_query(x, dbname = "cats", selector = list(furry = TRUE))$docs
#> [[1]]
#> [[1]]$`_id`
#> [1] "bluecat"
#> 
#> [[1]]$`_rev`
#> [1] "1-41784f190c466d990684003a958c9f39"
#> 
#> [[1]]$name
#> [1] "leo"
#> 
#> [[1]]$color
#> [1] "blue"
#> 
#> [[1]]$furry
#> [1] TRUE
#> 
#> [[1]]$size
#> [1] 1
```

Return only certain fields


```r
db_query(x, dbname = "cats",
         selector = list(size = list(`$gt` = 2)),
         fields = c("name", "color"))$docs
#> [[1]]
#> [[1]]$name
#> [1] "samson"
#> 
#> [[1]]$color
#> [1] "red"
#> 
#> 
#> [[2]]
#> [[2]]$name
#> [1] "matilda"
#> 
#> [[2]]$color
#> [1] "green"
```

Convert the result of a query into a data.frame using `jsonlite`


```r
library('jsonlite')
res <- db_query(x, dbname = "cats",
                 selector = list(`_id` = list(`$gt` = NULL)),
                 fields = c("name", "color", "furry", "size", "age"),
                 as = "json")

fromJSON(res)$docs
#>      name color furry size age
#> 1  samson   red FALSE    3  NA
#> 2 matilda green FALSE    5   2
#> 3     leo  blue  TRUE    1  NA
```


