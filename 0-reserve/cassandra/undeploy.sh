#!/bin/bash

kubeConfigFilePath=$(cat ../../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"



# kubectl --kubeconfig ../$kubeConfigFilePath delete -k ./k8s -n k8ssandra-operator

# helm --kubeconfig ../$kubeConfigFilePath uninstall k8ssandra-operator -n k8ssandra-operator 
kubectl --kubeconfig ../$kubeConfigFilePath delete namespace  k8ssandra-operator