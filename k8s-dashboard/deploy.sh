#!/bin/bash

kubectl --kubeconfig ../devops/env-0/token/admin.conf apply -k ./k8s
# kubectl --kubeconfig ../devops/te-0/token/admin.conf apply -k ./k8s