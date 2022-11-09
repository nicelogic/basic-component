#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

helm --kubeconfig $kubeConfigFilePath repo add mongodb https://mongodb.github.io/helm-charts
helm --kubeconfig $kubeConfigFilePath repo update

helm --kubeconfig $kubeConfigFilePath install enterprise-operator mongodb/enterprise-operator --namespace mongodb --create-namespace

kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s -n k8ssandra-operator

kubectl --kubeconfig $kubeConfigFilePathget k8cs -n k8ssandra-operator

