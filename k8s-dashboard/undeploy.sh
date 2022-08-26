#!/bin/bash

kubectl --kubeconfig ../devops/env-0/token/admin.conf delete -k ./k8s
# kubectl --kubeconfig ../devops/env-0/token/admin.conf delete namespace kubernetes-dashboard