#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/namespace.yaml
# kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s

kubectl create -f https://download.elastic.co/downloads/eck/2.4.0/crds.yaml

