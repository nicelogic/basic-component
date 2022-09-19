#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

# kubectl --kubeconfig $kubeConfigFilePath create -f k8s/setup

kubectl --kubeconfig $kubeConfigFilePath create -f k8s/
