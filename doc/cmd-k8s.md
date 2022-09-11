
# cmd

## k8s

### namespace context

kubectl config set-context --current --namespace minio-operator
kubectl config set-context --current --namespace tenant-0
kubectl config set-context --current --namespace k8ssandra-operato	r


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
kubectl delete pod traefik-697b8d8dd-xtn7z  --grace-period=0 --force --namespace traefik

### 给node去除污点

kubectl taint nodes --all node-role.kubernetes.io/control-plane- 
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint node node-2 node-role.kubernetes.io/master-
kubectl taint node node-2 node-role.kubernetes.io/control-plane-

### 重新加上污点

kubectl taint nodes node-3 node-role.kubernetes.io/master=:NoSchedule
kubectl taint nodes node-3 node-role.kubernetes.io/control-plane=:NoSchedule

kubectl taint nodes node-3 node-role.kubernetes.io/master=:PreferNoSchedule





