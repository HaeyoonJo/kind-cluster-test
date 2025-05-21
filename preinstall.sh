#!/bin/bash

# Install Kind
if ! command -v kind &> /dev/null
then
    echo "Installing Kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
    chmod +x ./kind
    mv ./kind /usr/local/bin/kind
else
    echo "Kind is already installed."
fi

# Install kubectl
if ! command -v kubectl &> /dev/null
then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
else
    echo "kubectl is already installed."
fi

# Install Python
if ! command -v python3 &> /dev/null
then
    echo "Installing Python..."
    apt update && apt install -y python3 python3-pip
else
    echo "Python is already installed."
fi

# Create Kind cluster
kind create cluster --config kind_config.yaml

# Apply Kubernetes resources
kubectl apply -f kind_configmap.yaml
kubectl apply -f tls-secret.yaml
kubectl apply -f local-volume.yaml

# Deploy Python service
kubectl apply -f python-deployment.yaml
kubectl apply -f python-service.yaml

echo "Setup complete. Access the webpage using the service's external IP and port."