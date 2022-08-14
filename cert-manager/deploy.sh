#!/bin/bash

# kubectl --kubeconfig ../devops/env-0/token/admin.conf apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml
# kubectl --kubeconfig ../devops/env-0/token/admin.conf apply -k ./k8s
# kubectl --kubeconfig ../devops/env-0/token/admin.conf delete -k ./k8s
kubectl --kubeconfig ../devops/te-0/token/admin.conf apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.9.1/cert-manager.yaml