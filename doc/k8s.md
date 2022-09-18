
# k8s

## cmd

```cmd

minikube start --image-repository=registry.cn-hangzhou.aliyuncs.com/google_containers --vm-driver=hyperv --hyperv-virtual-switch=minikube
minikube.exe kubectl -- get pods

kubectl get nodes


kubectl get deployments
kubectl del deployment xxx
kubectl rollout restart deployment mongo

kubectl get pods
kubectl get events

    kubectl.exe exec -ti niceice-web-656d679884-gkqgj -- bash
kubectl exec -it redis -- redis-cli

```

## concept

### basic

* node: kubelet, 容器运行时，kube-proxy
* Deployment 负责创建和更新应用程序的实例
* 可以使用kubectl drain 和 PodDisruptionBudgets， kubectl cordon
  你可以同时使用 kubectl drain 和 PodDisruptionBudgets 来保证你的服务在维护过程中仍然可用。如果使用 drain 来隔离节点并在此之前删除 pods 使节点进入离线维护状态，如果服务表达了 disruption budget，这个 budget 将被遵守

### 名字空间

Kubernetes 支持多个虚拟集群，它们底层依赖于同一个物理集群。 这些虚拟集群被称为名字空间。

### 标签和选择

基于等值的标签要求的一种使用场景是 Pod 要指定节点选择标准。 例如，下面的示例 Pod 选择带有标签 "accelerator=nvidia-tesla-p100"。

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: cuda-test
spec:
  containers:
    - name: cuda-test
      image: "k8s.gcr.io/cuda-vector-add:v0.1"
      resources:
        limits:
          nvidia.com/gpu: 1
  nodeSelector:
    accelerator: nvidia-tesla-p100 #标签 accelerator
```

```txt
environment=production,tier!=frontend
environment in (production, qa) //production或者qa
tier notin (frontend, backend)
partition
!partition
partition in (customerA, customerB),environment!=qa
```

```cmd
kubectl get pods -l environment=production,tier=frontend
kubectl get pods -l 'environment in (production),tier in (frontend)'
```

```yaml
selector:
  matchLabels:
    component: redis
  matchExpressions:
    - {key: tier, operator: In, values: [cache]}
    - {key: environment, operator: NotIn, values: [dev]}
```

### 注解

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: annotations-demo
  annotations: # 注解
    imageregistry: "https://hub.docker.com/"
spec:
  containers:
  - name: nginx
    image: nginx:1.7.9
    ports:
    - containerPort: 80
```

### 字段选择器

本质上是资源过滤
kubectl get pods --field-selector status.phase=Running

不同的 Kubernetes 资源类型支持不同的字段选择器。 所有资源类型都支持 metadata.name 和 metadata.namespace 字段。 使用不被支持的字段选择器会产生错误

### node affinity

* requiredDuringSchedulingIgnoredDuringExecution
表示pod必须部署到满足条件的节点上，如果没有满足条件的节点，就不停重试。其中IgnoreDuringExecution表示pod部署之后运行的时候，如果节点标签发生了变化，不再满足pod指定的条件，pod也会继续运行。

* requiredDuringSchedulingRequiredDuringExecution
表示pod必须部署到满足条件的节点上，如果没有满足条件的节点，就不停重试。其中RequiredDuringExecution表示pod部署之后运行的时候，如果节点标签发生了变化，不再满足pod指定的条件，则重新选择符合要求的节点。

* preferredDuringSchedulingIgnoredDuringExecution
表示优先部署到满足条件的节点上，如果没有满足条件的节点，就忽略这些条件，按照正常逻辑部署。

* preferredDuringSchedulingRequiredDuringExecution
表示优先部署到满足条件的节点上，如果没有满足条件的节点，就忽略这些条件，按照正常逻辑部署。其中RequiredDuringExecution表示如果后面节点标签发生了变化，满足了条件，则重新调度到满足条件的节点。

```yaml
affinity:
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
                - key: "app"
                  operator: In
                  values:
                  - zk
            topologyKey: "kubernetes.io/hostname"
```

requiredDuringSchedulingRequiredDuringExecution 告诉 Kubernetes 调度器，在以 topologyKey 指定的域中，绝对不要把带有键为 app，值为 zk 的标签的两个 Pods 调度到相同的节点。topologyKey kubernetes.io/hostname 表示这个域是一个单独的节点。使用不同的 rules、labels 和 selectors，你能够通过这种技术把你的 ensemble 在物理、网络和电力故障域之间分布。

### pod存活性探针和可读性探针(livenessProbe & readinessProbe)

* 可读性不同于存活性。如果一个进程是存活的，它是可调度和健康的。如果一个进程是就绪的，它应该能够处理输入。存活性是可读性的必要非充分条件。在许多场景下，特别是初始化和终止过程中，一个进程可以是存活但没有就绪。
* 如果你指定了一个可读性探针，Kubernetes将保证在可读性检查通过之前，你的应用不会接收到网络流量

```yaml
readinessProbe:
        exec:
          command:
          - sh
          - -c
          - "zookeeper-ready 2181"
        initialDelaySeconds: 10
        timeoutSeconds: 5
livenessProbe:
        exec:
          command:
          - sh
          - -c
          - "zookeeper-ready 2181"
        initialDelaySeconds: 10
        timeoutSeconds: 5

```

## Replication Controller

```cmd
kubectl scale rc cassandra --replicas=4
```

## deployment

```cmd
kubectl get rs(replicaSet)
kubectl create deployment kubernetes-bootcamp --image=gcr.io/google-samples/kubernetes-bootcamp:v1
kubectl create deployment kubernetes-bootcamp --image=registry.aliyuncs.com/google_containers/echoserver:1.4

```

kubectl通过api和k8s api-server通信，是master node的一部分

create deployment做了哪些事:

* searched for a suitable node where an instance of the application could be run (we have only 1 available node)
* scheduled the application to run on that Node
* configured the cluster to reschedule the instance on a new Node when needed

三者等价:
kubectl apply -f <https://k8s.io/examples/application/deployment.yaml> --record
kubectl run nginx --image nginx
kubectl create deployment nginx --image nginx

删除两个配置文件中定义的对象:
kubectl delete -f nginx.yaml -f redis.yaml

通过覆盖活动配置来更新配置文件中定义的对象：
kubectl replace -f nginx.yaml

### deployment更新

Deployment 可确保在更新时仅关闭一定数量的 Pod。默认情况下，它确保至少所需 Pods 75% 处于运行状态（最大不可用比例为 25%）。

```yaml
apiVersion: apps/v1 # for versions before 1.9.0 use apps/v1beta2
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

```cmd
更新 nginx Pod 以使用 nginx:1.16.1 镜像
kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1 --record
kubectl edit deployment.v1.apps/nginx-deployment
  将 .spec.template.spec.containers[0].image 从 nginx:1.14.2 更改至 nginx:1.16.1
kubectl rollout status deployment.v1.apps/nginx-deployment
kubectl rollout history deployment.v1.apps/nginx-deployment
kubectl rollout history deployment.v1.apps/nginx-deployment --revision=2
//回滚
kubectl rollout undo deployment.v1.apps/nginx-deployment --to-revision=2
```

### 缩放deployments

```cmd
kubectl scale deployment.v1.apps/nginx-deployment --replicas=10
kubectl autoscale deployment.v1.apps/nginx-deployment --min=10 --max=15 --cpu-percent=80
kubectl get hpa //Horizo​​ntalPodAutoscaler
kubectl delete hpa nginx-deployment
```

## DaemonSet

* nodeSelector 属性，它允许 DaemonSet 以全部节点的一个子集为目标

```cmd

kubectl get daemonset --namespace=kube-system

```

## node

* 一个 pod 总是运行在 工作节点
* 工作节点是 Kubernetes 中的参与计算的机器，可以是虚拟机或物理计算机，具体取决于集群
* 每个工作节点由主节点管理
* 主节点的自动调度考量了每个工作节点上的可用资源
* 每个 Kubernetes 工作节点至少运行:
    * Kubelet，负责 Kubernetes 主节点和工作节点之间通信的过程; 它管理 Pod 和机器上运行的容器。
    * 容器运行时（如 Docker）负责从仓库中提取容器镜像，解压缩容器以及运行应用程序

## pod

```cmd
kubectl get pods --show-labels
vkubectl get pods --all-namespaces
kubectl.exe get pods -o wide //能够多显示内容，包括所在node
kubectl get pods -l run=my-nginx -o wide
kubectl label pod $POD_NAME app=v1
kubectl logs -f redis-master-7d557b94bb-9qjgd
kubectl describe pods authentication-service-996b9fb86-97dmr //查看为什么pod是pending状态
kubectl get pods -w -l app=nginx //-w 持续查看状态
kubectl get pods --all-namespaces -o=jsonpath='{range .items[*]}{"\n"}{.metadata.name}{":\t"}{range .spec.containers[*]}{.image}{", "}{end}{end}' |\
sort //列出所有镜像
```

Pods that are running inside Kubernetes are running on a private, isolated network

pod(逻辑主机)(k8s原子单元) =  

* set of docker images
* 共享存储，当作卷
* 网络，作为唯一的集群 IP 地址
* 有关每个容器如何运行的信息，例如容器映像版本或要使用的特定端口。

## statefulSet

```cmd
kubectl get statefulset web
kubectl scale sts web --replicas=5
kubectl patch sts web -p '{"spec":{"replicas":3}}'
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate"}}}'
kubectl patch statefulset web --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"nginx:1.18.0"}]'
kubectl rollout status sts/<name>

//分段更新,前3个会保持不变，更新image,只会影响后面的版本
//如果更新了 StatefulSet 的 .spec.template，则所有序号大于或等于分区的 Pod 都将被更新
//如果一个序号小于分区的 Pod 被删除或者终止，它将被按照原来的配置恢复
//将 partition 改变为 0 以允许 StatefulSet 控制器继续更新过程
kubectl patch statefulset web -p '{"spec":{"updateStrategy":{"type":"RollingUpdate","rollingUpdate":{"partition":3}}}}'

//查看pod image
kubectl get po web-1 --template '{{range $i, $c := .spec.containers}}{{$c.image}}{{end}}'

```

### statefulset 删除

* 非级联删除，不删除pod
* podManagementPolicy这个参数，默认为OrderedReady，可以设置为Parallel

```cmd
kubectl delete statefulset web --cascade=false
kubectl delete statefulset web //默认级联
```

## service

Kubernetes 中的服务(Service)是一种抽象概念，它定义了 Pod 的逻辑集和访问 Pod 的协议。Service 使从属 Pod 之间的松耦合成为可能。 Service 下的一组 Pod 通常由 LabelSelector来标记。
一个 Service 由一组 backend Pod 组成
service的出现也是解决delopyment会重启Pod,pod ip会变的情况

service可以通过label定义这些pod的用途。Pod是纯粹的服务。而service是实际匹配了如何使用这些服务。
service通过给pod加上各种各样的属性(label).再通过这些标签来分类服务。服务A是指匹配这些属性的POD。
可以指定哪些pod是用于测试的。这样平台的所有测试环境都可以共享出来。指定哪些服务是测试用的，哪些是开发用的。

正如前面所提到的，一个 Service 由一组 backend Pod 组成。这些 Pod 通过 endpoints 暴露出来。 Service Selector 将持续评估，结果被 POST 到一个名称为 my-nginx 的 Endpoint 对象上。 当 Pod 终止后，它会自动从 Endpoint 中移除，新的能够匹配上 Service Selector 的 Pod 将自动地被添加到 Endpoint 中。 检查该 Endpoint，注意到 IP 地址与在第一步创建的 Pod 是相同的。

* service 可以通过svc name去访问。可以实验： 在pod中ping svc name. pod会优先访问相同namespace中的svc


```cmd
kubectl expose deployment/niceice-web --type="NodePort" --port 443
kubectl expose deployment/my-nginx
kubectl get svc my-nginx
kubectl expose deployment niceice-web --type=LoadBalancer --name=my-service
kubectl delete service -l app=redis
//默认type=cluster,nodeport则node port是有范围要求的(30000-32767)
kubectl expose deployment niceice-web --port=443 --target-port=443
kubectl port-forward redis-master-765d459796-258hz 7000:6379
```

## endpoint

```cmd
kubectl get ep
```

## ingress

```cmd
nginx.ingress.kubernetes.io/ssl-redirect: 'true'
```

### dns

```cmd
kubectl get services kube-dns --namespace=kube-system
```

## job

```cmd
kubectl apply -f https://kubernetes.io/examples/controllers/job.yaml
kubectl delete jobs/pi 或者 kubectl delete -f ./job.yaml
```

* .spec.activeDeadlineSeconds 优先级高于其 .spec.backoffLimit 设置
* restartPolicy 对应的是 Pod，而不是 Job 本身： 一旦 Job 状态变为 type: Failed，就不会再发生 Job 重启的动作.换言之，由 .spec.activeDeadlineSeconds 和 .spec.backoffLimit 所触发的 Job 终结机制 都会导致 Job 永久性的失败，而这类状态都需要手工干预才能解决
* 删除 old Job，但 允许该 Job 的 Pod 集合继续运行。 这是通过 kubectl delete jobs/old --cascade=false 实现
* Job 与副本控制器是彼此互补的。 副本控制器管理的是那些不希望被终止的 Pod （例如，Web 服务器）， Job 管理的是那些希望被终止的 Pod（例如，批处理作业）所以Job 仅适合于 restartPolicy 设置为 OnFailure 或 Never 的 Pod。 注意：如果 restartPolicy 未设置，其默认值是 Always

## configmap

```cmd
kubectl create configmap game-config-2 --from-file=configure-pod-container/configmap/game.properties
kubectl create configmap game-config --from-file=configure-pod-container/configmap/
kubectl describe configmaps game-config
kubectl get configmaps game-config -o yaml
kubectl get cm zk-config -o yaml
```

将 ConfigMap 中定义的 special.how 值分配给 Pod 规范中的 SPECIAL_LEVEL_KEY 环境变量

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
        # Define the environment variable
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
              name: special-config
              # Specify the key associated with the value
              key: special.how
  restartPolicy: Never
```

## secrets

```cmd
kubectl get secrets
kubectl get secret aliyun-credentials --output=yaml
kubectl create secret tls niceice-ingress-secret --cert=1_niceice.cn_bundle.crt --key=2_niceice.cn.key

```

## volume

```cmd
kubectl get pvc -l app=nginx
```

## kustomization

```cmd
kubectl apply -k .
kubectl get -k .
kubectl delete -k .
```

## addons


## debug

```cmd
kubectl run curl --image=radial/busyboxplus:curl -i --tty

kubectl run -i --tty --image busybox:1.28 dns-test --restart=Never --rm
nslookup web-0.nginx
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-0.nginx
Address 1: 10.244.1.6

nslookup web-1.nginx
Server:    10.0.0.10
Address 1: 10.0.0.10 kube-dns.kube-system.svc.cluster.local

Name:      web-1.nginx
Address 1: 10.244.2.6


kubectl run -it --rm --restart=Never alpine --image=alpine sh
iptables-save | grep niceice-web
kubectl cluster-info dump

```

k8s debug非侵入式，直接运行一个工具镜像，用于查询其他Pod的网络

### 从私有仓库拉取镜像

```cmd
docker login --username=niceice220 registry.cn-shanghai.aliyuncs.com

kubectl create secret docker-registry aliyun-credentials-sh \
  --docker-server=registry.cn-shanghai.aliyuncs.com \
  --docker-username=niceice220 \
  --docker-password=Ccccc123! \
  --docker-email=358844436@qq.com
```

## miscellaneous

```cmd
KUBE_EDITOR="nano" kubectl edit svc/docker-registry
kubectl replace -f xxx.yaml
kubectl -n kube-system describe $(kubectl -n kube-system get secret -n kube-system -o name | grep namespace) | grep token

kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')

```

## k3s

export K3S_EXTERNAL_IP=121.4.140.35
curl -sfL <https://get.k3s.io> | sh -
k3sfile path: /etc/rancher/k3s/k3s.yaml
/usr/local/bin/k3s-uninstall.sh
curl -sLS <https://get.k3s.io> | INSTALL_K3S_EXEC='server --tls-san 121.4.140.35' sh -

scp root@niceice.cn:/etc/rancher/k3s/k3s.yaml ./

## 从外部访问service

kubectl port-forward svc/mongodb 27017:27017



## source & kubeadm

* timedatectl set-timezone Asia/Shanghai //修改时区
* swapoff -a  //+注释/etc/fstab中swap 部分
* sudo apt install docker.io -y
* systemctl enable docker
* 按照官网流程进行安装(但是需要替换下kubeadm, kubelet, kubectl下载的源)
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
echo "deb  https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

* 安装完kubeadm,kubelet,kubectl之后, 更改docker配置，关闭swap分区
master/worker 都需要修改docker的cgroup driver:
```txt
/etc/docker/daemon.json

{
  "exec-opts": ["native.cgroupdriver=systemd"]
}

systemctl restart docker
docker info | grep Cgroup

```

<!-- kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=0.0.0.0  --pod-network-cidr=172.16.0.0/16 --service-cidr=10.1.0.0/16 --control-plane-endpoint=175.24.200.221 -->

* kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=0.0.0.0  --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=175.24.200.221

kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=0.0.0.0  --pod-network-cidr=10.244.0.0/16 --control-plane-endpoint=192.168.2.19

* echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bash_profile
* source ~/.bash_profile
* kubectl taint nodes --all node-role.kubernetes.io/control-plane- 


kubectl apply -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl delete -f https://github.com/coreos/flannel/raw/master/Documentation/kube-flannel.yml
more /run/flannel/subnet.env
<!-- kubeadm init --image-repository registry.aliyuncs.com/google_containers --apiserver-advertise-address=175.24.200.221 --pod-network-cidr=172.16.0.0/16 --service-cidr=10.1.0.0/16 --control-plane-endpoint=175.24.200.221 -->

//如果初次init失败

kubeadm reset
systemctl restart kubelet




kubectl get nodes  --show-labels
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint node node-2 node-role.kubernetes.io/master-
kubectl taint node node-2 node-role.kubernetes.io/control-plane-


查看worker node日志
journalctl -u kubelet -f

### kubeadm join

kubeadm token create --print-join-command

 kubeadm join 175.24.200.221:6443 --token 1kiur9.951jeia2lywnd0pq \
	--discovery-token-ca-cert-hash sha256:644c3ab0a1ca8e19aa44bb19a6f836f5a2e3ab984a803d94906d5cdb4db65368 \
	--control-plane 

//在master node 
kubectl -n kube-system rollout restart deployment coredns 

kubeadm join 175.24.200.221:6443 --token 1kiur9.951jeia2lywnd0pq --discovery-token-ca-cert-hash sha256:644c3ab0a1ca8e19aa44bb19a6f836f5a2e3ab984a803d94906d5cdb4db65368  --node-name slave-1

kubeadm reset

kubeadm join 192.168.1.200:8443 --token qfafcm.9r4u88bl4oxitq1o --discovery-token-ca-cert-hash sha256:22e3a5ca03cfe7e1af2c1b0be48aba06ef45e5655077cb73f7c823a6cab42e35 --control-plane 192.168.1.101:6443



### 问题解决

iptables -t nat -A OUTPUT -d 172.17.0.13 -j DNAT --to-destination 1.15.174.162
<!-- iptables -t nat -A OUTPUT -d 10. -j DNAT --to-destination 1.15.174.162 -->

 ifconfig cni0 down
 ip link delete cni0
 ifconfig cni0



## dashboard

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml


kubectl proxy --address='0.0.0.0'  --accept-hosts='^*$' --port=8001
http://192.168.1.100:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

https://:<apiserver-port>/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

kubectl apply -f dashboard-adminuser.yaml
kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

## namespace


kubectl config set-context --current --namespace minio-opertor
kubectl config set-context --current --namespace kubernetes-dashboard
kubectl config set-context --current --namespace mongodb
kubectl config view | grep namespace:
kubectl apply -f pod.yaml --namespace=test


## env 

kubectl exec mongo-588f59796b-z9qhz -- printenv | grep SERVICE


## 腾讯云组云联网失败

docker可能会占用组网的cidr

* vim /etc/docker/daemon.json
  {
    "default-address-pools":
    [
      {"base":"10.10.0.0/16","size":24}
    ]
  }
* service docker restart



## error fix

### kube-apiserver开启一段时间后，起不来（high-availability模式)

错误打印
```log
root@node-0:~# docker logs 8fa483abf3c4 | tail -f
I0505 15:17:32.914760       1 server.go:565] external host was not specified, using 192.168.1.100
I0505 15:17:32.915461       1 server.go:172] Version: v1.23.6
I0505 15:17:33.321314       1 shared_informer.go:240] Waiting for caches to sync for node_authorizer
I0505 15:17:33.322097       1 plugins.go:158] Loaded 12 mutating admission controller(s) successfully in the following order: NamespaceLifecycle,LimitRanger,ServiceAccount,NodeRestriction,TaintNodesByCondition,Priority,DefaultTolerationSeconds,DefaultStorageClass,StorageObjectInUseProtection,RuntimeClass,DefaultIngressClass,MutatingAdmissionWebhook.
I0505 15:17:33.322110       1 plugins.go:161] Loaded 11 validating admission controller(s) successfully in the following order: LimitRanger,ServiceAccount,PodSecurity,Priority,PersistentVolumeClaimResize,RuntimeClass,CertificateApproval,CertificateSigning,CertificateSubjectRestriction,ValidatingAdmissionWebhook,ResourceQuota.
I0505 15:17:33.323185       1 plugins.go:158] Loaded 12 mutating admission controller(s) successfully in the following order: NamespaceLifecycle,LimitRanger,ServiceAccount,NodeRestriction,TaintNodesByCondition,Priority,DefaultTolerationSeconds,DefaultStorageClass,StorageObjectInUseProtection,RuntimeClass,DefaultIngressClass,MutatingAdmissionWebhook.
I0505 15:17:33.323195       1 plugins.go:161] Loaded 11 validating admission controller(s) successfully in the following order: LimitRanger,ServiceAccount,PodSecurity,Priority,PersistentVolumeClaimResize,RuntimeClass,CertificateApproval,CertificateSigning,CertificateSubjectRestriction,ValidatingAdmissionWebhook,ResourceQuota.
W0505 15:17:53.327837       1 clientconn.go:1331] [core] grpc: addrConn.createTransport failed to connect to {127.0.0.1:2379 127.0.0.1 <nil> 0 <nil>}. Err: connection error: desc = "transport: authentication handshake failed: read tcp 127.0.0.1:34268->127.0.0.1:2379: i/o timeout". Reconnecting...
E0505 15:17:53.327884       1 run.go:74] "command failed" err="context deadline exceeded"
```

docker rm -f $(docker ps -qa)

## crd

crd object里， 可以查看crd支持的配置

## log

当使用某 CRI 容器运行时 时，kubelet 要负责对日志进行轮换，并管理日志目录的结构。 kubelet 将此信息发送给 CRI 容器运行时，后者将容器日志写入到指定的位置。 在 kubelet 配置文件 中的两个 kubelet 参数 containerLogMaxSize 和 containerLogMaxFiles 可以用来配置每个日志文件的最大长度和每个容器可以生成的日志文件个数上限。

https://kubernetes.io/zh-cn/docs/reference/config-api/kubelet-config.v1beta1/

containerLogMaxSize是定义容器日志文件被轮转之前可以到达的最大尺寸。 例如："5Mi" 或 "256Ki"。
默认值："10Mi"

containerLogMaxFiles
int32	
containerLogMaxFiles设置每个容器可以存在的日志文件个数上限。
默认值："5"

说明： 如果有外部系统执行日志轮转或者使用了 CRI 容器运行时，那么 kubectl logs 仅可查询到最新的日志内容。 比如，对于一个 10MB 大小的文件，通过 logrotate 执行轮转后生成两个文件， 一个 10MB 大小，一个为空，kubectl logs 返回最新的日志文件，而该日志文件在这个例子中为空。

基于上述存储，一个pod最多50M存储，则每个机器上还是需要一个系统启动盘用于存储基础pod日志
其他盘专门用于数据存储