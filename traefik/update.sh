#!/bin/bash


kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

helm --kubeconfig $kubeConfigFilePath upgrade traefik traefik/traefik --namespace=traefik --values=traefik-chart-values.yaml --set nodeSelector.ingresscontroller=traefik  