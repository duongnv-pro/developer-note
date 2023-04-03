<!-- @format -->

# Docker Tutorial

![](https://i.imgur.com/waxVImv.png)

### [View all DevNotes](../README.md)

![](https://i.imgur.com/waxVImv.png)

#### Install Elasticsearch with Docker #elasticsearch #docker

###### Pulling the image

```bash
sudo docker pull docker.elastic.co/elasticsearch/elasticsearch:7.13.3
// docker pull elasticsearch:5.6.8
```

###### Config elasticsearch

```bash
vim  /etc/security/limits.conf
add line below
* soft nofile 65536
* hard nofile 65536

vim /etc/sysctl.conf
add line below
vm.max_map_count=655360

sysctl -p
reboot // restart Computer
```

###### Starting a single node cluster with Docker

```bash
sudo docker run -id --name=es-gc -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.13.3
// docker run -id --name=es -p 9200:9200 -p 9300:9300 elasticsearch:5.6.8
// name container is es, can rename
docker rename es-gc new-name
```

###### Add Kuromoji

```bash
sudo docker start es-gc
sudo docker exec -it es-gc /bin/bash
sudo docker restart es-gc
```

###### Start, Stop and Restart

```bash
docker restart es
docker stop es
docker start es
```

###### Check all container

```bash
docker ps -a
```

###### Final check

```bash
curl http://localhost:9200
```
