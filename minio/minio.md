
# minio

## cmd

kubectl config set-context --current --namespace minio-operator
kubectl config set-context --current --namespace tenant-0

kubectl get pod kube-controller-manager-node3-control-plane -n kube-system -o yaml

export MINIO_SERVER_URL="https://tenant0.minio.env0.luojm.com:9443"


## init

<!-- wget <https://github.com/minio/operator/releases/download/v4.2.7/kubectl-minio_4.2.7_linux_amd64> -O kubectl-minio
chmod +x kubectl-minio
mv kubectl-minio /usr/local/bin/ -->

wget https://github.com/minio/operator/releases/download/v4.4.16/kubectl-minio_4.4.16_linux_amd64 -O kubectl-minio
chmod +x kubectl-minio
mv kubectl-minio /usr/local/bin/

kubectl minio version

kubectl create namespace tenant-0
kubectl minio tenant create tenant-0       \
  --servers                 2                    \
  --volumes                 4                   \
  --capacity                30Gi                 \
  --storage-class           local-hostpath \
   --namespace  tenant-0

  kubectl get svc --namespace minio-tenant-1

## info

Username: admin
Password: 12a52881-750a-415a-a212-ea0213fa3176


## k8s 

// kubectl minio init --namespace base --cluster-domain env0.minio.luojm.com
此处切记： 设置cluster domain之后, tenant部署之后，会用这个作为url一部分去访问
私有云的情况下，路由器端口映射等原因，可能经常访问不了
看Pod的日志可以得出这里会阻塞住，一直crash

kubectl minio proxy -n base 

kubectl minio tenant delete  base --namespace base
kubectl minio tenant create  base --servers 2 --volumes 4 --capacity 10Gi --storage-class minio-local-storage --namespace base

----

kubectl minio init  
kubectl minio init  --cluster-domain 10.1.0.1
kubectl minio proxy  

kubectl create ns minio-tenant-base
kubectl minio tenant create  tenant-0 --servers 2 --volumes 4 --capacity 200Gi --storage-class local-hostpath  --namespace tenant-0

kubectl minio delete -n minio-tenant-base
kubectl minio tenant delete  minio-base-tenant-1 -n minio-tenant-base

## monitor

kubectl minio tenant  info minio-base-tenant-1 -n minio-base

---

## error

### ERROR Unable to validate passed arguments in MINIO_ARGS:env+tls://s7T9j6cBCi7zkXoy4eUn:1HlD93hX8UOFoSRmpiBjeMa1rjoAuvw6qSde9DBn@operator.minio-base.svc.cluster.local:4222/webhook/v1/getenv/minio-base/minio-base: Get "https://operator.minio-base.svc.cluster.local:4222/webhook/v1/getenv/minio-base/minio-base?key=MINIO_ARGS": context deadline exceeded


## back

Tenant 'minio-base-tenant-1' created in 'minio-tenant-base' Namespace

  Username: admin 
  Password: 932740e2-5972-483f-9ed6-344ef05528e4 
  Note: Copy the credentials to a secure location. MinIO will not display these again.

+-------------+-----------------------------+-------------------+--------------+--------------+
| APPLICATION | SERVICE NAME                | NAMESPACE         | SERVICE TYPE | SERVICE PORT |
+-------------+-----------------------------+-------------------+--------------+--------------+
| MinIO       | minio                       | minio-tenant-base | ClusterIP    | 443          |
| Console     | minio-base-tenant-1-console | minio-tenant-base | ClusterIP    | 9443  

mc alias set tenant-base https://minio-tenant-base.luojm.com admin  932740e2-5972-483f-9ed6-344ef05528e4
mc ls tenant-base/test


## faq

### 如果生成的url偶尔是本地的偶尔是外网的

可能是pod只重启了一个， 在环境变量变更之后
rollout sts只会重启一个


### tenant console原理及内网部署须知


## mc

 mc alias set env0 https://tenant0.minio.env0.luojm.com:9443 V8xoBJAn8IYpOerT egVTkHkcCGzCaP3MwkaPBU4SQA88T3qe
 mc ls env0/bucket-0
 mc share download env0/bucket-0/379_1661761509.mp4