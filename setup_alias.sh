#!/bin/bash

# Set up aliases for kubectl
aliases=(
    "alias k='kubectl'"
    "alias kaf='kubectl apply -f'"
    "alias kcc='kubectl config current-context'"
    "alias kccc='kubectl config get-contexts'"
    "alias kctx='kubectl config use-context'"
    "alias kd='kubectl describe'"
    "alias kex='kubectl exec -it'"
    "alias kga='kubectl get all'"
    "alias kgc='kubectl get configmaps'"
    "alias kgd='kubectl get deployments'"
    "alias kgn='kubectl get nodes'"
    "alias kgp='kubectl get pods'"
    "alias kgrs='kubectl get replicasets'"
    "alias kgs='kubectl get services'"
    "alias kl='kubectl logs'"
    "alias kpf='kubectl port-forward'"
    "alias krm='kubectl delete'"
    "alias kud='kubectl rollout undo deployment'"
)

for alias_cmd in "${aliases[@]}"; do
    if ! grep -q "$alias_cmd" ~/.bashrc; then
        echo "$alias_cmd" >> ~/.bashrc
    fi
done

echo "Aliases for kubectl have been added to ~/.bashrc."

# Source the updated bashrc
source ~/.bashrc
