#!/bin/bash


kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

helm --kubeconfig $kubeConfigFilePath upgrade pulsar apache/pulsar --namespace=pulsar  --values ./values.yaml