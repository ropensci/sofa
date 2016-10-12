<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{sofa introduction}
%\VignetteEncoding{UTF-8}
-->



sofa introduction
=========

CouchDB links

+ [Apache CouchDB](http://couchdb.apache.org/).
+ [CouchDB guide - online book and hard copy](http://guide.couchdb.org/).

## CouchDB versions

`sofa` is built targeting CouchDB v2 or greater.

## Install CouchDB

Go to <http://docs.couchdb.org/en/2.0.0/install/index.html> for instructions.

## Start CouchDB in your terminal

You can do this from anywhere in your directory. See <http://couchdb.apache.org> for instructions on how to install CouchDB. You can't use `sofa` functions without having couchdb running, either locally or on a remote server. If using a remote sever of course you don't need to have CouchDB running locally.

```bash
couchdb
```

You can interact with your CouchDB databases as well in your browser. Navigate to http://localhost:5984/_utils

## Install sofa

Stable version


```r
install.packages("sofa")
```

Development version


```r
devtools::install_github("rbison", "ropensci")
```

Load library


```r
library(sofa)
```

## sofa package API

The folloing is a breakdown of the major groups of functions - note that not all are included.

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
* `db_updates`

__work with views/design documents__

* `design_copy`
* `design_create`
* `design_create_`
* `design_delete`
* `design_get`
* `design_head`
* `design_info`
* `design_search`

__work with documents__

* `doc_create`
* `doc_delete`
* `doc_get`
* `doc_head`
* `doc_update`
* `db_bulk_create`
* `db_bulk_update`

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
#> [1] "2.0.0"
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
#> [1] "e6bb43092edaf8fd987434b8a30cfbdf"
#> 
#> $rev
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
```

and one more, cause 3's company


```r
doc3 <- '{"name": "matilda", "color": "green", "furry": false, "size": 5}'
doc_create(x, dbname = "cats", doc3)
#> $ok
#> [1] TRUE
#> 
#> $id
#> [1] "e6bb43092edaf8fd987434b8a30d02c1"
#> 
#> $rev
#> [1] "1-73443af61b0149e4c3e138b870e72602"
```

Note how we used a document id in the first document creation, but
not in the second. Using a document id is optional.

## Changes feed


```r
db_changes(x, "cats")
#> $results
#> $results[[1]]
#> $results[[1]]$seq
#> [1] "1-g1AAAAB5eJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbpyWkmxsZIRNAx5j8liAJEMDkPoPMi2RIQsAxs4mmQ"
#> 
#> $results[[1]]$id
#> [1] "e6bb43092edaf8fd987434b8a30d02c1"
#> 
#> $results[[1]]$changes
#> $results[[1]]$changes[[1]]
#> $results[[1]]$changes[[1]]$rev
#> [1] "1-73443af61b0149e4c3e138b870e72602"
#> 
#> 
#> 
#> 
#> $results[[2]]
#> $results[[2]]$seq
#> [1] "2-g1AAAACbeJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbpyWkmxsZIRNAx5j8liAJEMDkPqPYpqRhYmxabIBNn1ZAGwiMGg"
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
#> [1] "3-g1AAAACbeJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbpyWkmxsZIRNAx5j8liAJEMDkPoPNY0JbJqRhYmxabIBNn1ZAGxEMGk"
#> 
#> $results[[3]]$id
#> [1] "e6bb43092edaf8fd987434b8a30cfbdf"
#> 
#> $results[[3]]$changes
#> $results[[3]]$changes[[1]]
#> $results[[3]]$changes[[1]]$rev
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
#> 
#> 
#> 
#> 
#> 
#> $last_seq
#> [1] "3-g1AAAACbeJzLYWBgYMpgTmEQTM4vTc5ISXLIyU9OzMnILy7JAUklMiTV____PyuDOZExFyjAbpyWkmxsZIRNAx5j8liAJEMDkPoPNY0JbJqRhYmxabIBNn1ZAGxEMGk"
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
#> 
#> 
#> [[2]]
#> [[2]]$`_id`
#> [1] "e6bb43092edaf8fd987434b8a30cfbdf"
#> 
#> [[2]]$`_rev`
#> [1] "1-08aef850a23f5ff95869c9cf5d9604dc"
#> 
#> [[2]]$name
#> [1] "samson"
#> 
#> [[2]]$color
#> [1] "red"
#> 
#> [[2]]$furry
#> [1] FALSE
#> 
#> [[2]]$size
#> [1] 3
#> 
#> 
#> [[3]]
#> [[3]]$`_id`
#> [1] "e6bb43092edaf8fd987434b8a30d02c1"
#> 
#> [[3]]$`_rev`
#> [1] "1-73443af61b0149e4c3e138b870e72602"
#> 
#> [[3]]$name
#> [1] "matilda"
#> 
#> [[3]]$color
#> [1] "green"
#> 
#> [[3]]$furry
#> [1] FALSE
#> 
#> [[3]]$size
#> [1] 5
```

Search for cats that are red


```r
db_query(x, dbname = "cats", selector = list(color = "red"))$docs
#> [[1]]
#> [[1]]$`_id`
#> [1] "e6bb43092edaf8fd987434b8a30cfbdf"
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
db_query(x, dbname = "cats", selector = list(size = list(`$gt` = 2)))$docs
#> [[1]]
#> [[1]]$`_id`
#> [1] "e6bb43092edaf8fd987434b8a30cfbdf"
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
#> [1] "e6bb43092edaf8fd987434b8a30d02c1"
#> 
#> [[2]]$`_rev`
#> [1] "1-73443af61b0149e4c3e138b870e72602"
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
