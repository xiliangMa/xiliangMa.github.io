# 容器部署 mysql 8.0

#### 下载镜像
```
docker pull 
```

#### 启动 mysql
> 1. 指定存储目录  <path> 例如: /opt/diss-backend-mysql:/var/lib/mysql 
> 2. 指定密码 <pwd> 例如: MYSQL_ROOT_PASSWORD=123 

```
docker run -d  --name diss-backend-mysql  -v <path>:/var/lib/mysql -p 3306:3306 --restart=unless-stopped  -e MYSQL_ROOT_PASSWORD=<pwd> mysql:8.0
```
 

#### 添加用户、配置权限
> 1. 修改用户 <user>
> 2. 修改密码 <pwd>
```
1. 创建用户
    create user '<user>'@'%' identified by '<pwd>';

2. 用户添加访问权限访问所有数据库:
    GRANT ALL PRIVILEGES ON *.* TO '<user>'@'%' WITH GRANT OPTION;
```

#### 更改加密方式
> 由于新版本的加密方式不同，导致更改权限后无法远程访问。
> 1. 修改用户 <user>
> 2. 修改密码 <pwd>

```
解决方法如下:

1. 更改加密方式
    ALTER USER '<user>'@'%' IDENTIFIED BY '<pwd>' PASSWORD EXPIRE NEVER; 
2. 更新用户密码
    ALTER USER '<user>'@'%' IDENTIFIED WITH mysql_native_password BY '<pwd>'; 
```