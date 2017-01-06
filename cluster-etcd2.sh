#!/bin/sh

REGISTRY_HOST=registry.aliyuncs.com/xygame

sudo docker stop etcd
sudo docker rm etcd
sudo docker run -d -v /usr/share/ca-certificates/:/etc/ssl/certs -p 4001:4001 -p 2380:2380 -p 2379:2379 \
 -v /data/etcd:/data/etcd \
 --name etcd $REGISTRY_HOST/etcd:v2.3.7 \
 -name etcd2 \
 -data-dir /data/etcd \
 -advertise-client-urls http://172.16.10.223:2379,http://172.16.10.223:4001 \
 -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
 -initial-advertise-peer-urls http://172.16.10.223:2380 \
 -listen-peer-urls http://0.0.0.0:2380 \
 -initial-cluster-token etcd-cluster-1 \
 -initial-cluster etcd1=http://172.16.10.222:2380,etcd2=http://172.16.10.223:2380,etcd3=http://172.16.10.224:2380 \
 -initial-cluster-state new
