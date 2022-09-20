#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath create -f manifests/setup
kubectl --kubeconfig $kubeConfigFilePath create -f manifests/
