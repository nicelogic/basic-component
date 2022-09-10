#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s -n k8ssandra-operator



helm --kubeconfig ../0-env/env-0/token/admin.conf upgrade k8ssandra-operator k8ssandra/k8ssandra-operator -n k8ssandra-operator -f k8s/cassandra.yaml 
# helm --kubeconfig ../0-env/env-0/token/admin.conf upgrade k8ssandra-operator k8ssandra/k8ssandra-operator -n k8ssandra-operator --reuse-values --set cassandra.datacenters\[0\].size=3,cassandra.datacenters\[0\].name=dc1