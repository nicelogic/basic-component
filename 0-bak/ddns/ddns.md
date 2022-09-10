
# ddns

## duty

控制台： 192.168.1.201
每个环境都有一个对外出口的虚IP
理论上，所有外部流量只能访问该IP

如果是端口映射的情况（家庭情况），则需要DDNS来将外网IP映射到域名，然后该外网IP通过端口映射的方式
转发所有流量到虚IP

## domain

### env level

env0.luojm.com
22->22

### platform level 

k8s.env0.luojm.com
9443->443
minio.env0.luojm.com
9443->443
tenant0.minio.env0.luojm.com
9443->443
console.tenant0.minio.env0.luojm.com
9443->443

### app level

warmth.luojm.com


## bak

env0.luojm.com
traefik.env0.luojm.com
k8s.env0.luojm.com
minio.env0.luojm.com
tenant0.minio.env0.luojm.com
console.tenant0.minio.env0.luojm.com
auth.cassandra.env0.luojm.com
graphql.cassandra.env0.luojm.com
cql.cassandra.env0.luojm.com
warmth.luojm.com
