
# traefik

## init

helm repo add traefik https://helm.traefik.io/traefik
helm repo update
helm install traefik traefik/traefik -n=base --set DNSPOD_API_KEY=512d3dc73a3db3d97b33f92517afc7cc  --values=traefik-chart-values.yaml



kubectl port-forward $(kubectl get pods -n=traefik --selector "app.kubernetes.io/name=traefik" --output=name) 9000:9000  -n=traefik --address='0.0.0.0'

kubectl logs -f $(kubectl get pods -n=traefik --selector "app.kubernetes.io/name=traefik" --output=name) -n traefik

helm uninstall traefik -n traefik
helm install traefik traefik/traefik --namespace=traefik --values=traefik-chart-values.yaml
helm upgrade traefik traefik/traefik --namespace=traefik --values=traefik-chart-values.yaml

Helm --kubeconfig tecent-cloud/base.luojm.com/token/admin.conf uninstall traefik -n traefik
helm --kubeconfig tecent-cloud/base.luojm.com/token/admin.conf install traefik traefik/traefik --namespace=traefik --values=k8s/traefik/traefik-chart-values.yaml --set nodeSelector."kubernetes\.io/role"=master

helm --kubeconfig tecent-cloud/base.luojm.com/token/admin.conf install traefik traefik/traefik --namespace=traefik --values=k8s/traefik/traefik-chart-values.yaml --set nodeSelector."kubernetes\.io/hostname"=vm-12-7-ubuntu

helm --kubeconfig tecent-cloud/base.luojm.com/token/admin.conf upgrade traefik traefik/traefik --namespace=traefik --values=k8s/traefik/traefik-chart-values.yaml --set nodeSelector."kubernetes\.io/hostname"=vm-12-7-ubuntu

kubectl get pods --all-namespaces

kubectl --kubeconfig tecent-cloud/base.luojm.com/token/admin.conf apply -k k8s/traefik/k8s 


helm --kubeconfig ./env/admin.conf uninstall traefik -n traefik


```yaml


entryPoints:
  web:
    address: ":80"

  websecure:
    address: ":443"

certificatesResolvers:
  myresolver:
    acme:
      # ...
      dnsChallenge:
        provider: DNSPod
        delayBeforeCheck: 0


```


dnspod-token: 512d3dc73a3db3d97b33f92517afc7cc