#!/bin/bash
images=(kube-proxy:v1.15.4 kube-scheduler:v1.15.4 kube-controller-manager:v1.15.4 kube-apiserver:v1.15.4 etcd:3.3.10 coredns:1.3.1 pause:3.1 )
for imageName in ${images[@]} ; do
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
docker tag  registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
docker rmi  registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done