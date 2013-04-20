thedude
=======

```python
if 
	the big lebowski ~ the dude 
then 
	CouchDB + R ~ thedude
```

duuuuuuude

## Install 

from github obviously

```r
install.packages("devtools")
library(devtools)
install_github("thedude", "schamberlain")
library(thedude)
```

## Quickstart

### Connect to CouchDB

In your terminal type `couchdb`

### Ping the server

```r
 dude_ping()
  couchdb   version 
"Welcome"   "1.2.1" 
```

### Create a new database, list databases

```r
dude_createdb(dbname='dudedb')

  ok 
TRUE 

dude_listdbs() # see if its there now

[1] "dudedb"
```

### 

```r

```