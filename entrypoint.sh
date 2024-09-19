#!/bin/bash

# Start Docker (since Docker is included, we run it directly)
dockerd &

# Determine if the node is a master or a worker based on environment variables
if [ "$NODE_ROLE" == "master" ]; then
    echo "Initializing Kubernetes master node..."
    kubeadm init --apiserver-advertise-address=$(hostname -i) --pod-network-cidr=10.10.0.0/16

    # Configure kubectl for the root user
    mkdir -p $HOME/.kube
    cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    chown $(id -u):$(id -g) $HOME/.kube/config

    # Install a CNI network (Flannel)
    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

elif [ "$NODE_ROLE" == "worker" ]; then
    echo "Joining Kubernetes worker node to master at $MASTER_IP..."
    kubeadm join $MASTER_IP:6443 --token $TOKEN --discovery-token-ca-cert-hash $DISCOVERY_HASH

else
    echo "NODE_ROLE not set. Exiting..."
    exit 1
fi

# Start kubelet for the node
exec kubelet

