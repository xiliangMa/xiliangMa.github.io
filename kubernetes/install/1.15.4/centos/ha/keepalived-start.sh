#!/bin/bash
# ----------------- 修改虚拟 IP 地址
VIRTUAL_IP=192.168.8.10
# ----------------- 网卡名
INTERFACE=ens33
# ----------------- 子网掩码
NETMASK_BIT=24
# ----------------- HAProxy 暴露端口，内部指向 kube-apiserver 的 6443 端口
CHECK_PORT=6444
# ----------------- 路由标识符
RID=10
# ----------------- 虚拟路由标识符
VRID=160
# ----------------- IPV4 多播地址，默认 224.0.0.18
MCAST_GROUP=224.0.0.18

docker run -itd --restart=always --name=Keepalived \
        --net=host --cap-add=NET_ADMIN \
        -e VIRTUAL_IP=$VIRTUAL_IP \
        -e INTERFACE=$INTERFACE \
        -e CHECK_PORT=$CHECK_PORT \
        -e RID=$RID \
        -e VRID=$VRID \
        -e NETMASK_BIT=$NETMASK_BIT \
        -e MCAST_GROUP=$MCAST_GROUP \
        wise2c/keepalived-k8s