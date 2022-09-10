#!/bin/bash

helm upgrade traefik traefik/traefik --namespace=traefik --values=traefik-chart-values.yaml