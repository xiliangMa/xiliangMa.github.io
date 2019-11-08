# ElasticSearch Metricbeat Kibana 以 docker 方式部署

## 1. ElasticSearch 部署
> ElasticSearch的默认端口是9200，我们把宿主环境9200端口映射到Docker容器中的9200端口，就可以访问到Docker容器中的ElasticSearch服务了，同时我们把这个容器命名为es


**1.1 下载镜像:**

```aidl
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.4.2
```

**1.2 启动：**
```aidl
docker run -d --name es -p 9200:9200 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.4.2
```

## 2. Kibana 部署

**2.1 下载镜像:**

```aidl
docker pull docker.elastic.co/kibana/kibana:7.4.2
```

**2.2 启动**:

> 替换 <YOUR_ELASTICSEARCH_CONTAINER_NAME_OR_ID>为第一步创建的 es 容器的 id，主要是讲 elasticsearch 数据接入 kibana 展示。

```aidl
docker run -d --name kibana  --link <YOUR_ELASTICSEARCH_CONTAINER_NAME_OR_ID>:elasticsearch -p 5601:5601 docker.elastic.co/kibana/kibana:7.4.2
```



## 3. metricbeat 部署 

**3.1 下载镜像:**
```
docker pull docker.elastic.co/beats/metricbeat:7.4.2
```

**3.2 启动:**
> 注意将 metricbeat.docker.yml 模板文件准备好

下载 metricbeat.docker.yml 模板文件：
```aidl
curl -L -O https://raw.githubusercontent.com/elastic/beats/7.4/deploy/docker/metricbeat.docker.yml
```

**3.3 启动 metricbeat 容器:**

```aidl
docker run -d \
  --name=mb \
  --user=root \
  --volume="$(pwd)/metricbeat.docker.yml:/usr/share/metricbeat/metricbeat.yml:ro" \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
  --volume="/proc:/hostfs/proc:ro" \
  --volume="/:/hostfs:ro" \
  docker.elastic.co/beats/metricbeat:7.4.2
```



## 4. metricbeat 配置 集成kibana、 elasticsearch

**4.1 进入容器:**
```aidl
docker exec -it mb bash
```

**4.2 启动 system 和 容器 监控 modules:**

```aidl
metricbeat modules enable system
metricbeat modules enable docker

```

**4.3 初始化配置:**
> 替换 kibanaIP、elasticsearchIP、user(默认为 elastic)、password（默认为 changeme）

```aidl
metricbeat -e \
  -E output.elasticsearch.hosts=["<elasticsearchIP>:9200"] \
  -E setup.kibana.host=<kibanaIP>:5601 \
  -E output.elasticsearch.username=<user> \
  -E output.elasticsearch.password=<password>
```


## 5. kibana 展示效果

**5.1 kibana system 监控效果如下**

![image](https://github.com/xiliangMa/xiliangMa.github.io/blob/master/images/kibana-system-001.png) 


**5.2 kibana 容器 监控效果如下**

![image](https://github.com/xiliangMa/xiliangMa.github.io/blob/master/images/kibana-docker-001.png) 
