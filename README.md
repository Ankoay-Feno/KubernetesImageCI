# KubernetesImageCI

**Description**:  
This Docker image sets up a Kubernetes node (either a master or a worker) using Alpine Linux as the base image. It includes all the necessary tools to initialize and manage Kubernetes clusters, such as `kubectl`, `kubeadm`, and `kubelet`, as well as Docker for container management.

This image simplifies the process of deploying Kubernetes clusters, either by initializing a master node or joining a worker node to an existing cluster. The role of the node (master or worker) is determined by environment variables passed during the container's runtime.

## Key Features:
- **Based on Alpine Linux**: Small, efficient, and secure base image.
- Includes **kubectl**, **kubeadm**, and **kubelet** for Kubernetes management.
- Installs and runs Docker within the container for managing containers on Kubernetes nodes.
- Supports both **master** and **worker** node roles based on environment variables.
- Automatically sets up a Flannel network for Kubernetes pods when initializing a master node.
- Exposes necessary ports for Kubernetes operation (6443, 2379, 2380, etc.).

## Usage:

1. **Pull the image**:
   ```bash
   docker pull ankoayfeno/kubernetes:latest```
2. **Run the Image**

The behavior of the container is determined by the environment variables:

### To run as a master node:
    ```bash
    docker run -d --name k8s-master \
    -e NODE_ROLE=master \
    -p 6443:6443 -p 2379:2379 -p 2380:2380 -p 10250:10250 \
    ankoayfeno/kubernetes:latest```

### To run as a worker node: provide the master node's IP, the token, and the discovery token hash
    ```bash
    docker run -d --name k8s-worker \
    -e NODE_ROLE=worker \
    -e MASTER_IP=<master-ip> \
    -e TOKEN=<your-token> \
    -e DISCOVERY_HASH=<your-discovery-hash> \
    ankoayfeno/kubernetes:latest```


### Exposed Ports
- 6443: Kubernetes API server
- 2379-2380: etcd server client API
- 10250: Kubelet API
- 30000-32767: NodePort services

