
# cert-manager

## 证书生成不成功问题排查

kubectl get issuer 
kubectl get ClusterIssuer 
kubectl describe certificate 
kubectl describe CertificateRequest 
kubectl describe Order certificate-dash-5qp6z-3580739920 -n traefik
kubectl describe Challenge -n traefik


## 关于cloudflare secret放在哪里可以生成证书的问题

https://github.com/cert-manager/cert-manager/issues/263

* 实验仅在cert-manager即可
* 实验仅在kube-system即可