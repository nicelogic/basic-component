#!/bin/bash

mkdir -p /opt/data/traefik/log

kubectl apply -f ./k8s/traefik-namespace.yaml
helm repo add traefik https://helm.traefik.io/traefik
helm repo update
# helm install traefik traefik/traefik --namespace=traefik --values=./traefik-chart-values.yaml --set nodeSelector.ingresscontroller=traefik --set="additionalArguments={--log.level=DEBUG}"
helm install traefik traefik/traefik --namespace=traefik --values=./traefik-chart-values.yaml --set nodeSelector.ingresscontroller=traefik 

kubectl apply -k ./k8s 