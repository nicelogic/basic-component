#!/bin/bash

cd script
./install-kubectl-minio-to-host.sh
./init-minio-k8s-operator.sh
cd ..

kubectl --kubeconfig ../devops/env-0/token/admin.conf apply -k ./k8s
