#!/bin/bash

#  kubectl --kubeconfig  ../0-env/env-0/token/admin.conf apply -k ./k8s

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/elasticsearch.yaml

