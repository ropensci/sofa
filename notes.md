## query examples

docs: <https://docs.cloudant.com/cloudant_query.html>

field `smell` with values greater than 5

```
curl -v -XPOST -H 'Content-Type: application/json' 'http://localhost:5984/farts/_find' -d '{
  "selector": {
    "smell": {
      "$gt": 5
    }
  }
}'
```

field `smell` with values greater than 5, and return only `_id` and `smell` fields

```
curl -v -XPOST -H 'Content-Type: application/json' 'http://localhost:5984/farts/_find' -d '{
  "selector": {
    "smell": {
      "$gt": 5
    }
  },
  "fields": [
    "_id",
    "smell"
  ]
}'
```


curl -v -XGET -H 'Content-Type: application/json' 'http://localhost:5984/_stats'
