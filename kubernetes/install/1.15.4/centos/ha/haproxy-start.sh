#!/bin/bash
# -----------------修改 Master 地址
MasterIP1=192.168.8.181
MasterIP2=192.168.8.182
MasterIP3=192.168.141.183

# ----------------- kube-apiserver 默认端口 6443 不需要修改
MasterPort=6443
HaproxyPort=6444

# 启动
docker run -d --restart=always --name=HAProxy -p $HaproxyPort:$HaproxyPort \
        -e MasterIP1=$MasterIP1 \
        -e MasterIP2=$MasterIP2 \
        -e MasterIP3=$MasterIP3 \
        -e MasterPort=$MasterPort \
        wise2c/haproxy-k8s