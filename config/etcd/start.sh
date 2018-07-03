#!/bin/bash
TOKEN=etcd-super
CLUSTER_STATE=existing
NAME_1=etcd-node-1
NAME_2=etcd-node-2
NAME_3=etcd-node-3
NAME_4=etcd-node-4

HOST_1=172.17.0.8
HOST_2=172.17.0.2
HOST_3=172.17.0.9
HOST_4=172.17.0.7

#CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380,${NAME_3}=http://${HOST_3}:2380,${NAME_4}=http://${HOST_4}:2380
CLUSTER=${NAME_1}=http://${HOST_1}:2380,${NAME_2}=http://${HOST_2}:2380

THIS_NAME=${NAME_2}
THIS_HOST=${HOST_2}

/cronsun-etcd/etcd/etcd \
	--name ${THIS_NAME} \
	--data-dir=/vue-msf/etcd/data \
	--initial-advertise-peer-urls http://${THIS_HOST}:2380 \
	--listen-peer-urls http://${THIS_HOST}:2380 \
	--advertise-client-urls http://${THIS_HOST}:2379 \
	--listen-client-urls http://${THIS_HOST}:2379,http://127.0.0.1:2379 \
	--initial-cluster-token ${TOKEN} \
	--initial-cluster-state ${CLUSTER_STATE} \
	--initial-cluster ${CLUSTER}


