#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

# helm --kubeconfig $kubeConfigFilePath repo add apache https://pulsar.apache.org/charts
# helm --kubeconfig $kubeConfigFilePath repo update
kubectl --kubeconfig $kubeConfigFilePath create namespace pulsar
helm --kubeconfig $kubeConfigFilePath install pulsar apache/pulsar --namespace=pulsar --timeout 10m --set initialize=true  --values ./values.yaml
