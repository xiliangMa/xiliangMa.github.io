# docker compose 部署 mysql 
> 1. 创建自动配置 root 密码
> 2. 自动添加 用户、密码、权限
> 3. 自动创建指定 数据库

#### docker-compose.yml

```
version: '3'
services:
  diss-db:
    restart: unless-stopped
    container_name: mysql-db
    image: mysql:5.7.14
    environment:
      MYSQL_ROOT_PASSWORD: diss #root密码
      MYSQL_USER: diss # 指定创建用户
      MYSQL_PASSWORD: diss # 指定创建用户密码
      MYSQL_DATABASE: diss # 指定创建的数据库
    ports:
      - 3306:3306
    volumes:
      - ./conf/my.cnf:/etc/my.cnf
```

#### my.conf
> 指定基础配置
```
[mysqld]
user=mysql
default-storage-engine=INNODB
character-set-server=utf8
[client]
default-character-set=utf8
[mysql]
default-character-set=utf8
```


#### 启动
```
docker-compose up -d
```


#### 删除
```
docker-compose down -v
```