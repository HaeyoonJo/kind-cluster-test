#!/bin/bash

# Update package lists
sudo apt-get update

# Check for Docker
if ! command -v docker >/dev/null 2>&1; then
  # Add Docker's official GPG key:
  sudo apt-get update && \
    sudo apt-get install ca-certificates curl -y && \
    sudo install -m 0755 -d /etc/apt/keyrings && \
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    sudo chmod a+r /etc/apt/keyrings/docker.asc

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update && \
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  
  sudo groupadd docker && \
    sudo usermod -aG docker $USER
  docker version
else
  echo "Docker already installed."
fi

# Check for kubectl
if ! command -v kubectl >/dev/null 2>&1; then
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
  kubectl version
else
  echo "kubectl already installed."
  kubectl version
fi

# Install Kind (assuming Go 1.16+ is installed)
if ! command -v kind >/dev/null 2>&1; then
    # For AMD64 / x86_64
    [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
    # For ARM64
    [ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-arm64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
else
  echo "Kind already installed."
fi

# Create a Kind cluster with name "my-cluster"
kind create cluster --name my-cluster
echo "Cluster creation successful. Use 'kubectl cluster-info --context kind-my-cluster' for details."

# You can delete cluster after checking its running.
# kind delete cluster --name my-cluster

# # add Alias
# alias k='kubectl'
# alias kaf='kubectl apply -f'
# alias kcc='kubectl config current-context'
# alias kccc='kubectl config get-contexts'
# alias kctx='kubectl config use-context'
# alias kd='kubectl describe'
# alias kex='kubectl exec -it'
# alias kga='kubectl get all'
# alias kgc='kubectl get configmaps'
# alias kgd='kubectl get deployments'
# alias kgn='kubectl get nodes'
# alias kgp='kubectl get pods'
# alias kgrs='kubectl get replicasets'
# alias kgs='kubectl get services'
# alias kl='kubectl logs'
# alias kpf='kubectl port-forward'
# alias krm='kubectl delete'
# alias kud='kubectl rollout undo deployment'