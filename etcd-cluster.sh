#!/bin/sh

EGISTRY=quay.io/coreos/etcd
ETCD_VERSION=v3.2.10
TOKEN=etcd-token
CLUSTER_STATE=new
NAME_1=etcd-node-0
NAME_2=etcd-node-1
NAME_3=etcd-node-2
HOST_1=172.19.8.8
HOST_2=172.19.8.9
HOST_3=172.19.8.10
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380
DATA_DIR=/var/lib/etcd

# For node 1
case $1 in
        "node1")
                THIS_NAME=${NAME_1}
                THIS_IP=${HOST_1}
        ;;
        "node2")
                THIS_NAME=${NAME_2}
                THIS_IP=${HOST_2}
        ;;
        "node3")
                THIS_NAME=${NAME_3}
                THIS_IP=${HOST_3}
        ;;
        *)
                echo "node number error!"
                exit
        ;;
esac

docker run \
  -d \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${REGISTRY}:${ETCD_VERSION} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name ${THIS_NAME} \
  --initial-advertise-peer-urls http://${THIS_IP}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${THIS_IP}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster ${CLUSTER} \
  --initial-cluster-state ${CLUSTER_STATE} --initial-cluster-token ${TOKEN}
