#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath delete -k ./k8s
# kubectl --kubeconfig $kubeConfigFilePath delete namespace cert-manager
