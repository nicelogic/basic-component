#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath create -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/examples/client-secure-operator.yaml -n cockroach-operator-system