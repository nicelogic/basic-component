#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

# helm --kubeconfig $kubeConfigFilePath repo add k8ssandra https://helm.k8ssandra.io/stable
# helm --kubeconfig $kubeConfigFilePath repo update

# helm --kubeconfig $kubeConfigFilePath install k8ssandra-operator k8ssandra/k8ssandra-operator -n k8ssandra-operator --create-namespace

kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s -n k8ssandra-operator

kubectl --kubeconfig $kubeConfigFilePathget k8cs -n k8ssandra-operator

