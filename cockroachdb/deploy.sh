#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/install/crds.yaml

kubectl --kubeconfig $kubeConfigFilePath apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/install/operator.yaml

