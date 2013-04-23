sofa
=======

#### *An easy interface to CouchDB from R*


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

from github obviously

```ruby
install.packages("devtools")
library(devtools)
install_github("sofa", "schamberlain")
library(sofa)
```

### Ping the server

```ruby
 sofa_ping()

  couchdb   version 
"Welcome"   "1.2.1" 
```

Nice, it's working.

### Create a new database, and list available databases

```ruby
sofa_createdb(dbname='sofadb')

  ok 
TRUE 

sofa_listdbs() # see if its there now

[1] "sofadb"
```

### Create documents

#### Write a document WITH a name (uses PUT)
```ruby
doc1 <- '{"name":"sofa","beer":"IPA"}'
sofa_writedoc(dbname="sofadb", doc=doc1, docid="sofasbeer")

$ok
[1] TRUE

$id
[1] "sofasbeer"

$rev
[1] "3-60b547ef0b162af1b3891f1955d46e66"
```

#### Write a json document WITHOUT a name (uses POST)
```ruby
doc2 <- '{"name":"sofa","icecream":"rocky road"}'
sofa_writedoc(dbname="sofadb", doc=doc2)

$ok
[1] TRUE

$id
[1] "a1812100bd1dba00c2ed1cd507000b92"

$rev
[1] "1-5406480672da172726810767e7d0ead3"
```

#### Write an xml document WITH a name (uses PUT). The xml is written as xml in couchdb, just wrapped in json, when you get it out it will be as xml.

```ruby
# write the xml
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
sofa_writedoc(dbname="sofadb", doc=doc3, docid="somexml")

$ok
[1] TRUE

$id
[1] "somexml"

$rev
[1] "5-493a2080920f9843459326b50ad358a1"

# get the doc back out
sofa_getdoc(dbname="sofadb", docid="somexml")

                                       _id 
                                 "somexml" 
                                      _rev 
      "5-493a2080920f9843459326b50ad358a1" 
                                       xml 
"<top><a/><b/><c><d/><e>bob</e></c></top>" 

# get just the xml out
sofa_getdoc(dbname="sofadb", docid="somexml")[["xml"]]

[1] "<top><a/><b/><c><d/><e>bob</e></c></top>"
```


### Full text search? por sepuesto

#### Install Elasticsearch (on OSX)

+ Download zip or tar file
+ unzip or untar
+ sudo mv /path/to/elasticsearch-0.20.6 /usr/local
+ cd /usr/local
+ sudo ln -s elasticsearch-0.20.6 elasticsearch

#### Install CouchDB plugin for Elasticsearch

+ cd elasticsearch
+ bin/plugin -install elasticsearch/elasticsearch-river-couchdb/1.1.0

#### Start Elasticsearch

+ cd elasticsearch
+ start elasticsearch: bin/elasticsearch -f

#### Make call to elasticsearch to start indexing (and always index) your database

Edit details and paste into terminal and execute

curl -XPUT 'localhost:9200/_river/rplos_db/_meta' -d '{
    "type" : "couchdb",
    "couchdb" : {
        "host" : "localhost",
        "port" : 5984,
        "db" : "rplos_db",
        "filter" : null
    }
}'

#### Searching

##### At the cli...

```sh
curl -XGET "http://localhost:9200/sofadb/_search?q=road&pretty=true"

{
  "took" : 3,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.614891,
    "hits" : [ {
      "_index" : "sofadb",
      "_type" : "sofadb",
      "_id" : "a1812100bd1dba00c2ed1cd507000277",
      "_score" : 0.614891, "_source" : {"_rev":"1-5406480672da172726810767e7d0ead3","_id":"a1812100bd1dba00c2ed1cd507000277","name":"sofa","icecream":"rocky road"}
    }, {
      "_index" : "sofadb",
      "_type" : "sofadb",
      "_id" : "a1812100bd1dba00c2ed1cd507000b92",
      "_score" : 0.13424811, "_source" : {"_rev":"1-5406480672da172726810767e7d0ead3","_id":"a1812100bd1dba00c2ed1cd507000b92","name":"sofa","icecream":"rocky road"}
    } ]
  }
}
```

##### In R...

```ruby
sofa_search(dbname="sofadb", q="road")

...

$hits$hits[[3]]
$hits$hits[[3]]$`_index`
[1] "sofadb"

$hits$hits[[3]]$`_type`
[1] "sofadb"

$hits$hits[[3]]$`_id`
[1] "a1812100bd1dba00c2ed1cd507000277"

$hits$hits[[3]]$`_score`
[1] 1

$hits$hits[[3]]$`_source`
$hits$hits[[3]]$`_source`$`_rev`
[1] "1-5406480672da172726810767e7d0ead3"

$hits$hits[[3]]$`_source`$`_id`
[1] "a1812100bd1dba00c2ed1cd507000277"

$hits$hits[[3]]$`_source`$name
[1] "sofa"

$hits$hits[[3]]$`_source`$icecream
[1] "rocky road"
```

##### And you can have sofa process the results from CouchDB

```ruby

```