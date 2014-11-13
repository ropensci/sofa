# write a document WITH a name (uses PUT)
doc1 <- '{"name":"dude","beer":"IPA"}'
sofa_writedoc(dbname="sofadb", doc=doc1, docid="dudesbeer")

# write a json document WITHOUT a name (uses POST)
doc2 <- '{"name":"dude","icecream":"rocky road"}'
sofa_writedoc(dbname="sofadb", doc=doc2)

# write an xml document WITH a name (uses PUT). xml is written as xml in 
# couchdb, just wrapped in json, when you get it out it will be as xml
doc3 <- "<top><a/><b/><c><d/><e>bob</e></c></top>"
sofa_writedoc(dbname="sofadb", doc=doc3, docid="somexml")

sofa_getdoc(dbname="sofadb", docid="somexml")[["xml"]]

sofa_deldoc(dbname="sofadb", docid="somexml")


# using with rplos

library(thedude)
library(rplos)
library(RJSONIO)
library(httr)

## initiate couchdb
sofa_createdb(dbname="rplos_db")
options("rplos_couchdb" = "rplos_db")

# Make a call to the PLoS ALM API
alm(doi="10.1371/journal.pone.0029797")

# Make another call, but this time simultaneously write to your CouchDB database
alm(doi="10.1371/journal.pone.0029797", write2couch=TRUE)

# Start tracking with elasticsearch (See readme), then search it
results <- elasticsearch(dbname="rplos_db", q="scienceseeker")
results$hits$hits[[1]]$`_source`

# make lots of calls
dois <- searchplos(terms='evolution', fields='id', limit = 75)
out <- alm(doi=as.character(dois[,1])[1:5], write2couch=TRUE)
lapply(out, head)