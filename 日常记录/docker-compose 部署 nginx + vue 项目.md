> 采用 npm run 的模式启动 vue 项目 端口 8080
> nginx 8089 做代理转发到 vue 8080

#### 1. 准备 vue 项目的 Dockerfile
> 比较简单将vue项目做成 docker镜像 直接启动即可。

```bash
FROM node:12
MAINTAINER user "xxx@xxx.com"

EXPOSE 8080

WORKDIR /usr/share/workpath  #替换成自己的目录
COPY . /usr/share/workpath   #替换成自己的目录
RUN  npm install

CMD ["npm", "run", "dev"]
```
编译镜像：
```bash
docker build -t test-vue .
```

启动测试：
```bash
docker run --name=test-vue -d \
-p 8080:8080 \
test-vue
```
#### 2. 准备 nginx.conf
```bash
#user  nobody;
worker_processes  1;
events {
  worker_connections  1024;
}

http {
  include mime.types;
  default_type  application/octet-stream;

  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
  '$status $body_bytes_sent "$http_referer" '
  '"$http_user_agent" "$http_x_forwarded_for"';

  #access_log  logs/access.log  main;

  sendfile        on;
  #tcp_nopush     on;

  #keepalive_timeout  0;
  keepalive_timeout  65;

  #gzip  on;

  upstream test-vue {
    server diss-ui:8080; # 该处为docker-compose 容器的名称
  }

  #api服务配置
  server {
    listen 8089;
    server_name localhost;
    add_header 'Access-Control-Allow-Headers' 'Origin, X-Requested-With, Content-Type, Accept';
    add_header 'Access-Control-Allow-Origin' '*';
    add_header 'Access-Control-Allow-Credentials' 'true';
    add_header 'Access-Control-Allow-Methods' 'GET, POST, OPTIONS';
    charset utf-8;

    location / {
      proxy_pass http://test-vue;
        proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    }

  }
}
```

#### 3. 准备 Docker-Compose
```bash
version: '3'
services:
  diss-ui:
    restart: always
    container_name: test-vue
    image: test-vue
    ports:
      - "8080:8080"
    env_file:
      - ./test.env  # 需要的话可以指定环境变量传入做动态参数
    command: ["npm", "run", "dev"]

  diss-nginx:
    restart: always
    container_name: nginx
    image: nginx:1.17
    env_file:
      - test.env # 需要的话可以指定环境变量传入做动态参数
    depends_on:
      - diss-ui
    links:
      - diss-ui
    ports:
      - "8089:8089"
    volumes:
      - './nginx.conf:/etc/nginx/nginx.conf:ro'
    command: [nginx, '-g', 'daemon off;']


```


启动：
```bash
docker-compose up -d

```

停止：
```bash
docker-compose down -v

```