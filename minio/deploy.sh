#!/bin/bash

cd script
./install-kubectl-minio-to-host.sh
./init-minio-k8s-operator.sh
cd ..

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s