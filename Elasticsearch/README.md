# Complete Guide to Elasticsearch
- [Back](../README.md)
#### 1. Introduction
- How to write complex queries
  - E.g. for search, data analysis, APM, server monitoring, security, etc.
- No specific use case is covered
- Example of what is covered
  - Mapping, analyzers, synonyms, stemming, search-as-you-type, auto-completion, highlighting, relevance tuning, aggregations, etc.

###### Kibana
An analytics & visualization platform
Can manage parts of Elasticsearch and Logstash
Dashboards: CPU & Memory, Error, Agg,API response time, Sales, Revenue, etc.
###### Logstash
A data processing pipeline
log file entries, ecommere order, customers, chat messages, etc.

Example pipeline configuration
```
input {
  file {
    path => "/path/to/apache_access.log"
  }
}
filter {
  if [request] in ["/robots.txt", "/favicon.ico"] {
    drop { }
  }
}
output {
  file {
    path => "%{type}_%{+yyyy_MM_dd}.log"
  }
}
```
###### X-Pack
Adds additional features to the Elasticsearch & Kibana
Adds authentication and authorization
Monitorning
Alearting
Reporting
Machine Learning
Abnormality Detection
Forecasting
Graph
Elasticseach Query
###### Beats
filebeat
### 2. Getting Started
#### Get started setting up Elasticsearch and Kibana
