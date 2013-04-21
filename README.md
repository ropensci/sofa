thedude
=======

```ruby
if the big lebowski ~ the dude
	CouchDB + R ~ thedude
else
	duuuuuuude
```

## Install 

from github obviously

```ruby
install.packages("devtools")
library(devtools)
install_github("thedude", "schamberlain")
library(thedude)
```

## Quickstart

### Connect to CouchDB

In your terminal type `couchdb`

### Ping the server

```ruby
 dude_ping()

  couchdb   version 
"Welcome"   "1.2.1" 
```

### Create a new database, list databases

```ruby
dude_createdb(dbname='dudedb')

  ok 
TRUE 

dude_listdbs() # see if its there now

[1] "dudedb"
```

### Create documents

#### Write a document WITH a name (uses PUT)
```ruby
doc1 <- '{"name":"dude","beer":"IPA"}'
dude_writedoc(dbname="dudedb", doc=doc1, docid="dudesbeer")

$ok
[1] TRUE

$id
[1] "dudesbeer"

$rev
[1] "3-60b547ef0b162af1b3891f1955d46e66"
```

#### Write a json document WITHOUT a name (uses POST)
```ruby
doc2 <- '{"name":"dude","icecream":"rocky road"}'
dude_writedoc(dbname="dudedb", doc=doc2)

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
dude_writedoc(dbname="dudedb", doc=doc3, docid="somexml")

$ok
[1] TRUE

$id
[1] "somexml"

$rev
[1] "5-493a2080920f9843459326b50ad358a1"

# get the doc back out
dude_getdoc(dbname="dudedb", docid="somexml")

                                       _id 
                                 "somexml" 
                                      _rev 
      "5-493a2080920f9843459326b50ad358a1" 
                                       xml 
"<top><a/><b/><c><d/><e>bob</e></c></top>" 

# get just the xml out
dude_getdoc(dbname="dudedb", docid="somexml")[["xml"]]

[1] "<top><a/><b/><c><d/><e>bob</e></c></top>"
```