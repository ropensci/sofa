<!--
%\VignetteEngine{knitr}
%\VignetteIndexEntry{An R Markdown Vignette made with knitr}
-->

sofa - easy interface to CouchDB from R
======
  
### What is sofa?
  
XXXXXXX

It is getting easier to get data directly into R from the web. Often R packages that retrieve data from the web return useful R data structures to users like a data.frame. This is a good thing of course to make things user friendly. 

However, what if you want to drill down into the data that's returned from a query to a database in R?  What if you want to get that nice data.frame in R, but you think you may want to look at the raw data later? The raw data from web queries are often JSON or XML data. This type of data, especially JSON, can be easily stored in schemaless so-called NoSQL databases, and queried later. 

There are plenty of databases you can interact with from R, so why CouchDB? For one, it makes a lot of sense to write to a NoSQL database when you have JSON, XML, HTML, etc., which aren't a good fit for databases like MySQL, SQLite, PostgreSQL, etc. ([though postgres allows you to write JSON][postgres]). It didn't have to be CouchDB, but at least to me it seems relatively easy to install, you can interact with it via an HTTP API (if you're into that, which I am), and it has a nice web interface (navigate to [http://localhost:5984/_utils/](http://localhost:5984/_utils/) after starting `couchdb`).

### A brief aside: JSON and XML

What are JSON and XML? This is what JSON looks like (ps if you ever wonder if your JSON is correct, go [here](http://jsonlint.com/)):

```bash
{
  "name": "joe",
  "hobby": "codemonkey",
  "lives": [
      {
          "city": "San Jose",
          "state": "CA"
      }
  ]
}
```

This is what XML looks like:

```bash
<?xml version="1.0" encoding="UTF-8" ?>
  <name>joe</name>
  <hobby>codemonkey</hobby>
	<lives>
		<city>San Jose</city>
		<state>CA</state>
	</lives>
```

### CouchDB help

+ [Apache CouchDB](http://couchdb.apache.org/).
+ [CouchDB guide - online book and hard copy](http://guide.couchdb.org/).
+ [Couchapp - sort of like rails, for templating apps based on CouchDB](http://couchapp.org/page/index).

### Quick start

#### Start CouchDB in your terminal

You can do this from anywhere in your directory. See [here](http://couchdb.apache.org/) for instructions on how to install CouchDB. You can't use `sofa` functions without having couchdb running, either locally or on a remote server. If using a remote sever of course you don't need to have CouchDB running locally.

```bash
couchdb
```

#### Install sofa


```r
# install.packages('devtools'); library(devtools);
# install_github('rbison', 'ropensci')
library(sofa)
```

```


Start CouchDB on your command line by typing 'couchdb'

Then start Elasticsearch if using by opening a new terminal tab/window,
navigating to where it was installed and starting

On my Mac this is: cd /usr/local/elasticsearch then bin/elasticsearch -f

New to sofa? Tutorial at https://github.com/schamberlain/sofa.

Use suppressPackageStartupMessages() to suppress these startup messages in
the future
```


#### Ping your local server just to check your head

```r
sofa_ping()
```

```
$couchdb
[1] "Welcome"

$uuid
[1] "6524cce1bf020f7b8fc74616b57f09ff"

$version
[1] "1.3.0"

$vendor
$vendor$version
[1] "1.3.0-1"

$vendor$name
[1] "Homebrew"
```


#### Create a new database

```r
sofa_createdb("helloworld", delifexists = TRUE)
```

```
Error: unused argument (delifexists = TRUE)
```


#### List databases

```r
sofa_listdbs()
```

```
 [1] "_replicator"                "_users"                    
 [3] "alm_couchdb"                "alm_db"                    
 [5] "cheese"                     "deldbtesting"              
 [7] "dudedb"                     "example"                   
 [9] "foobar"                     "foodb"                     
[11] "getattachtesting"           "hello_earth"               
[13] "hello_world"                "helloworld"                
[15] "rplos_db"                   "shit"                      
[17] "shitty"                     "shitty2"                   
[19] "sofadb"                     "test_suite_db"             
[21] "test_suite_db/with_slashes" "test_suite_reports"        
[23] "testr2couch"                "twitter_db"                
```


### More in depth stuff

#### Working with documents

#### Working with a remote database

#### Attachements

#### The changes feed

#### Full text search

##### Start elasticsearch in your terminal

See [here](https://github.com/schamberlain/sofa) for instructions on how to install Elasticsearch and the River CouchDB plugin.

```bash
cd /usr/local/elasticsearch
bin/elasticsearch -f
```

***************

#### Incorporating sofa into web API calls

##### Install alm, branch "couch"

```r
# Uncomment these lines if you don't have these packages installed
install_github("alm", "ropensci", ref = "couch")
```

```
Error: could not find function "install_github"
```

```r
library(alm)
```


### Create a new database

```r
sofa_createdb(dbname = "alm_db", delifexists = TRUE)
```

```
Error: unused argument (delifexists = TRUE)
```


### Write couchdb database name to options

```r
options(couch_db_name = "alm_db")
```


### Search for altmetrics normally, w/o writing to a database

```r
head(alm(doi = "10.1371/journal.pone.0029797"))
```

```
          .id pdf html shares groups comments likes citations total
1   bloglines  NA   NA     NA     NA       NA    NA         0     0
2   citeulike  NA   NA      1     NA       NA    NA        NA     1
3    connotea  NA   NA     NA     NA       NA    NA         0     0
4    crossref  NA   NA     NA     NA       NA    NA         6     6
5      nature  NA   NA     NA     NA       NA    NA         4     4
6 postgenomic  NA   NA     NA     NA       NA    NA         0     0
```


### Search for altmetrics normally, while writing to a database

```r
head(alm(doi = "10.1371/journal.pone.0029797", write2couch = TRUE))
```

```
NULL
```


### Make lots of calls, and write them simultaneously

```r
# install_github('rplos', 'ropensci')
library(rplos)
dois <- searchplos(terms = "evolution", fields = "id", limit = 100)
out <- alm(doi = as.character(dois[, 1]), write2couch = TRUE)
lapply(out[1:2], head)
```

```
list()
```


### Writing data to CouchDB does take a bit longer

```r
system.time(alm(doi = as.character(dois[, 1])[1:60], write2couch = FALSE))
```

```
   user  system elapsed 
  1.733   0.020   3.347 
```

```r
system.time(alm(doi = as.character(dois[, 1])[1:60], write2couch = TRUE))
```

```
   user  system elapsed 
  0.040   0.008   1.247 
```



```
## [1] ""
```

