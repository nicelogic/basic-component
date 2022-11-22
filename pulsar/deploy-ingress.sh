#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

# helm --kubeconfig $kubeConfigFilePath repo add apache https://pulsar.apache.org/charts
# helm --kubeconfig $kubeConfigFilePath repo update
kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/ingress-route-pulsar-manager.yml
kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/ingress-route-proxy.yml