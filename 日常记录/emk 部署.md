# ElasticSearch Metricbeat Kibana 以docker 方式部署


## 1. ElasticSearch 部署

**1.1 下载镜像:**
```aidl
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.4.2
```

> ElasticSearch的默认端口是9200，我们把宿主环境9200端口映射到Docker容器中的9200端口，就可以访问到Docker容器中的ElasticSearch服务了，同时我们把这个容器命名为es

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
> 替换 kibanaIP、elasticsearchIP 

```aidl
docker run -d --name metricbeat docker.elastic.co/beats/metricbeat:7.4.2 setup -E setup.kibana.host=<kibanaIP>:5601 -E output.elasticsearch.hosts=<elasticsearchIP>:9200
```

**3.3 kibana 效果如下**

![image](https://github.com/xiliangMa/xiliangMa.github.io/blob/master/images/kibana_001.png) 

