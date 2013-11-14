smalliris <- iris[1:10,]
smalliris
library(RJSONIO)
rjson::toJSON(smalliris)
df2json(smalliris)

library(sofa)
# doc1 <- rjson::toJSON(smalliris)
doc1 <- df2json(smalliris)
doc1 <- gsub("\n", "", doc1)
doc2 <- paste0('{"metadata": {"journal":"Ecology","year":2009,"author":"Doe, John"}, "data_type": "table", "data": ', doc1, '}')
sofa_writedoc(dbname="scidat", doc=doc2, docid="smalliris")
# sofa_deldoc(dbname="scidat", docid="smalliris")
sofa_getdoc(dbname="scidat", docid="smalliris")

elastic_search(dbname="scidat", q="setosa")

sofa_changes(dbname="scidat")
