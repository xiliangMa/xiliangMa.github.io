#!/bin/bash
images=(kube-proxy:v1.16.0 kube-scheduler:v1.16.0 kube-controller-manager:v1.16.0 kube-apiserver:v1.16.0 etcd:3.3.15-0 coredns:1.6.2 pause:3.1 )
for imageName in ${images[@]} ; do
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
docker tag  registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
docker rmi  registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done