<!-- @format -->

# Complete Guide to Elasticsearch

- [Back](../README.md)

### Overview of installation options #elasticsearch

#### Install Elasticsearch
Let's send a request to Elasticsearch. To be precise, we will an HTTP request to the REST API.
* Elasticsearch is running on localhost at port 9200

To send the request, I will use the cURL command
```bash
curl http://localhost:9200
```

#### Install kibana
Download Kibana: https://www.elastic.co/downloads/kibana
* Kibana is running on localhost at port 5601

#### Understanding the base architecture
##### Sumary
* *Nodes* store the data that we add to Elasticsearch
* a *cluster* is a collection of nodes
* Data is stored as *documents*, which are JSON object
* Document are grouped together with *indices*

Node: a node is essentially an instance of ES that stores data.
Cluster: a cluster is collection of related nodes that together contain all of our data.
Document are JSON object containing whatever data you desire. When you index a document, the original JSON object that you sent to ES is stored.
The JSON object that we send to ES is stored within a field named "_source"

So how are documents organized?
> indices: Every document within Elasticsearch, is stored within an index

An index groups documents together logically,
as well as provide configuration options that are related to scalability and availability. An index is therefore a collection of documents that have similar characteristics and are logically related.
#### Inspecting the cluster #cluster
1. Open Kibana -> Dev Tools
2. Run command:
```
GET /_cluster/health

GET /_cat/nodes?v

GET /_cat/indices?v
```
Retrieve more node details

```
GET /_cat/_nodes
```
#### Sending queries with cURL #curl #query elasticsearch
##### with Kibana's Console
```
GET /_cluster/health

GET /.kibana/_search
{
  "query": {
    "match_all": {}
  }
}
```
##### with cURL
```
curl -xGET "http://localhost:9200/_cluster/health"

// Kibana's Consloe -> Copy as cURL
curl -xGET "http://localhos:9200/.kibana/_search" -H 'Content-Type: application/json' -d'{"query:"{"match_all":{}}}'

// with https
curl -xGET -u user_name:password "https://enpoint..." ...
```
#### Sharding and scalability
* Sharding is a way to device indices into smaller pieces
* Each piece is referred to as a *shard*
* Sharding is done at the index level
* The main purpose is to horizontally scale the data volume

Example:
* Node A(capacity: 500GB)
* Node B(capacity: 500GB)
* Index(600GB)

=> Divide the index into two shards: Shard A(300GB), Shard B(300GB)
Now can store a shard on each of the two nodes without running out of disk space.
For intance: we don't need to spread there out on five different nodes.
##### Let's dive a bit deeper ...
* A shard is an independent index.. *kind of*
* Each shard is an Apache Lucene index
* An ES index consists of one or more Lucne index
* A shard has no predefined size; it grows as documents are added to it
* A shard may store up to about two billion documents
* Mainly to be able to store more documents
* To easier fit large indices onto nodes
* Improved performance
  * Parallelization of queries increases the throughput of an index
* An index contains a single shard by defalt
* Indices in Elasticsearch < 7.0.0 were created with five shards
  * This often led to *over-sharding*
* Increase the number of shards with Split API
* Reduce the number of shards with Shrink API
```bash
GET /_cat/indices?v

# looking a columns "pri" - primary shards
```
#### Understanding replication
##### How does replication work?
- Replication works by creating copies of shards, referred to as `replica shards`
- A shard that has been replicated, is called a `primary shards`
- A primary shard and replica shards are referred to as `replication groups`
- Replica shards are a complete copy of a shard.
- A replica shard can serve search requests, exactly like its primary shards
- The number of replicas can be configured at index creation

Example index:
**Node A** - Replication group A:
  + Primary Shard A
  + Replica A1
  + Replica A2

**Node B** - Replication group B:
  + Primary Shard B
  + Replica B1
  + Replica B2

**With two node**
**Node A**
  + Shard A
  + Shard B

**Node B**
  + Replica A
  + Replica B


PUT /pages

GET /_cluster/health

GET /_cat/indices?v

GET /_cat/shards?v
