
# minio



## minio原理

k8s minio分为两个部分： 
  * minio-operator (包括其console)
  * minio-tenant (这个是核心，包括其console, log, prometheus等辅助组件)

minio tenant会读取secret: tenant-0-env-configuration 中环境变量
export MINIO_SERVER_URL="https://tenant0.minio.env0.luojm.com:9443"
作为对外开放的url。没有默认就是cluster.local
生成的share url/ mc alias连接的url都是这个地址

minio operator console的密码在： secret: console-sa-secret(当前是自己创建的，k8s 1.24.0 service account的token要自己去创建)

### minio root user

MinIO deployments have a root user with access to all actions and resources on the deployment, regardless of the configured identity manager. When a minio server first starts, it sets the root user credentials by checking the value of the following environment variables: MINIO_ROOT_USER.

## init

<!-- kubectl create namespace tenant-0
kubectl minio tenant create tenant-0       \
  --servers                 2                    \
  --volumes                 4                   \
  --capacity                200Gi                 \
  --storage-class           local-hostpath \
   --namespace  tenant-0 -->
tenant当前统一用minio operator console
创建完后，将enable tls去掉
需要支持log,需要创建log pv
需要支持prometheus,需要创建prometheus pv

## faq

## sharing url内网怎么办

export MINIO_SERVER_URL="https://tenant0.minio.env0.luojm.com:9443"
修改tenant0 secret: tenant-0-env-configuration, 这样生成的sharing的url就是公网地址的
否则默认是: cluster.local

### 为何minio init不设置cluster-domain

// kubectl minio init --namespace base --cluster-domain env0.minio.luojm.com
此处切记： 设置cluster domain之后, tenant部署之后，会用这个作为url一部分去访问
私有云的情况下，路由器端口映射等原因，可能经常访问不了
看Pod的日志可以得出这里会阻塞住，一直crash
此为特殊环境所需，不必设置cluster-domain

### 如果生成的url偶尔是本地的偶尔是外网的

可能是pod只重启了一个， 在环境变量变更之后
rollout sts只会重启一个

## 悬疑点

 一定要开放9080->80，且tenant console web端口打开, console才工作正常
 要不然会出现登录不上/console share不了的问题

