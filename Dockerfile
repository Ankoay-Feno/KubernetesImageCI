# Use the latest version of Alpine Linux as the base image
FROM docker:dind

# Environment variables
ENV K8S_VERSION=v1.25.0 \
    CRICTL_VERSION=v1.22.0

# Updates packages and installs necessary dependencies
RUN apk update && \
    apk add --no-cache \
        bash \
        curl \
        iptables \
        ebtables \
        socat \
        conntrack-tools \
        ca-certificates \
        iproute2 \
        util-linux \
        ipvsadm \
        runc \
        cni-plugins

# Download and install kubectl
RUN curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Download and install kubeadm
RUN curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubeadm" && \
    chmod +x kubeadm && \
    mv kubeadm /usr/local/bin/

# Download and install kubelet
RUN curl -LO "https://dl.k8s.io/release/${K8S_VERSION}/bin/linux/amd64/kubelet" && \
    chmod +x kubelet && \
    mv kubelet /usr/local/bin/

# Copy the initialization script and make it executable
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose necessary ports for the Kubernetes cluster
EXPOSE 6443 2379 2380 10250 10259 10257 10255 30000-32767

# Set the entry point
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
