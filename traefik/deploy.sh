#!/bin/bash

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

# mkdir -p /opt/data/traefik/log

kubectl --kubeconfig $kubeConfigFilePath apply -f ./k8s/traefik-namespace.yaml
helm --kubeconfig $kubeConfigFilePath repo add traefik https://helm.traefik.io/traefik
helm --kubeconfig $kubeConfigFilePath repo update
helm --kubeconfig $kubeConfigFilePath install traefik traefik/traefik --namespace=traefik --values=./traefik-chart-values.yaml --set nodeSelector.ingresscontroller=traefik 

kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s 

# helm install traefik traefik/traefik --namespace=traefik --values=./traefik-chart-values.yaml --set nodeSelector.ingresscontroller=traefik --set="additionalArguments={--log.level=DEBUG}"