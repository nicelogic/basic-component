
# cmd

## k8s

### namespace context

kubectl config set-context --current --namespace minio-operator
kubectl config set-context --current --namespace tenant-0
kubectl config set-context --current --namespace k8ssandra-operator
kubectl config set-context --current --namespace kube-logging
kubectl config set-context --current --namespace monitoring


### 强制删除namespace


kubectl get ns traefik -o json > traefik.json
vim traefik.json 
kubectl proxy --port=8081 &
curl -k -H "Content-Type: application/json" -X PUT --data-binary @traefik.json http://127.0.0.1:8081/api/v1/namespaces/traefik/finalize
ps aux | grep 'kubectl proxy'
pkill xxx


### 查看

kubectl  describe  node | grep Ta
kubectl get nodes  --show-labels

### 设置label

--add
kubectl label node node-4 ingresscontroller=traefik
--delete
kubectl label node node-3 ingresscontroller-
--update 
kubectl label node node-4 ingresscontroller=traefik --overwrite

### 强制删除pod
kubectl delete pod tenant-0-pool-0-1  --grace-period=0 --force --namespace tenant-0

## 暂停deployment

kubectl rollout pause deployment/cassandra-cluster-env0-dc1-default-stargate-deployment

### 给node去除污点

kubectl taint nodes --all node-role.kubernetes.io/control-plane- 
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint node node-2 node-role.kubernetes.io/master-
kubectl taint node node-2 node-role.kubernetes.io/control-plane-

### 重新加上污点

kubectl taint nodes node-3 node-role.kubernetes.io/master=:NoSchedule
kubectl taint nodes node-3 node-role.kubernetes.io/control-plane=:NoSchedule

kubectl taint nodes node-3 node-role.kubernetes.io/master=:PreferNoSchedule

### 强制删除pvc/pv

kubectl patch pvc data0-tenant-0-pool-0-0 -p '{"metadata":{"finalizers":null}}'
kubectl patch pv data0-tenant-0-pool-0-0 -p '{"metadata":{"finalizers":null}}'






