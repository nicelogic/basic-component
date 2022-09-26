
# cassandra


## cassandra cmd

kubectl config set-context --current --namespace k8ssandra-operator
kubectl describe k8cs cassandra-cluster-env0 -n k8ssandra-operator
kubectl describe cassandradatacenter dc1
kubectl rollout restart -n k8ssandra-operator deployment k8ssandra-operator


//测试部署之后状态, status: UN (代表up normal)->正常状态
CASS_USERNAME=$(kubectl get secret cassandra-cluster-env0-superuser -n k8ssandra-operator -o=jsonpath='{.data.username}' | base64 --decode)
CASS_PASSWORD=$(kubectl get secret cassandra-cluster-env0-superuser -n k8ssandra-operator -o=jsonpath='{.data.password}' | base64 --decode)
kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- nodetool -u $CASS_USERNAME -pw $CASS_PASSWORD status
kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- nodetool -u $CASS_USERNAME -pw $CASS_PASSWORD ring
kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- nodetool -u $CASS_USERNAME -pw $CASS_PASSWORD info

//测试操纵
kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD -e "CREATE KEYSPACE test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};"

kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD  -e "CREATE TABLE test.users (email text primary key, name text, state text);"

kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD -e "insert into test.users (email, name, state) values ('john@gamil.com', 'John Smith', 'NC');"

kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD -e "insert into test.users (email, name, state) values ('joe@gamil.com', 'Joe Jones', 'VA');"

kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD -e "insert into test.users (email, name, state) values ('sue@help.com', 'Sue Sas', 'CA');"

kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD -e "insert into test.users (email, name, state) values ('tom@yes.com', 'Tom and Jerry', 'NV');"

kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u $CASS_USERNAME -p $CASS_PASSWORD -e "select * from test.users;"

//进入cql命令行操作
//经过测试不可用
kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -- /bin/bash
ping cassandra-cluster-env0-dc3-stargate-service
cqlsh -u cassandra-cluster-env0-superuser -p znk4uVfaCLm6hppEZaJl cassandra-cluster-env0-dc1-stargate-service

## stargate

curl -L -X POST 'https://auth.cassandra.env0.luojm.com:9443/v1/auth' -H 'Content-Type: application/json' --data-raw '{"username": "cassandra-cluster-env0-superuser", "password": "znk4uVfaCLm6hppEZaJl"}'
kubectl exec -it cassandra-cluster-env0-dc1-default-sts-0 -n k8ssandra-operator -c cassandra -- cqlsh -u cassandra-cluster-env0-superuser -p znk4uVfaCLm6hppEZaJl

## basic

k8ssandra部署，一个node一个cassandra, stargate单独一个node.一般3个cassandra组个基本的完备的集群，所以worker最好有4个

## dev

### concept

primary key = partition key + cluster key, 要求primary key要能够唯一确定一行记录。
也就是说不能在一个table中出现完全相同的primary key

## faq

### 为什么酒店例子里面hotel_by_poi里要包含hotel name, phone等attribute

规范化的数据库里面是不包含的
但是cassandra需要包含
要不然就得先查询到hotel id, 再去hotel表里面去拿具体的数据
可以是可以，但是这就变成了两个步骤。
不是事务的步骤。
有可能查询的时候有hotel,但是去拿的时候hotel已经删除
类比之前的redis数据设计。也是基本上通过脚本的形式去拿数据。做成事务。数据设计还是规划化的。
还有一种是酒店这个例子里面： 

写的时候往hotel, hotel_by_poi里面都更新hotel的相关属性
读的时候就可以只读hotel_by_poi的表
