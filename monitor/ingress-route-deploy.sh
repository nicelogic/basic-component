#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/ingress-route-prometheus.yaml
kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/ingress-route-alertmanager.yaml
kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/ingress-route-grafana.yaml