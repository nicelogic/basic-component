#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath create namespace mongodb

kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s -n mongodb