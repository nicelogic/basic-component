
# cmd


## minio 

kubectl config set-context --current --namespace minio-operator
kubectl config set-context --current --namespace tenant-0

kubectl minio tenant  info tenant-0 -n tenant-0

用于检测minio是否可以自签证书
kubectl get pod kube-controller-manager-node3-control-plane -n kube-system -o yaml

### mc

 mc alias set env0 https://tenant0.minio.env0.luojm.com:9443 V8xoBJAn8IYpOerT egVTkHkcCGzCaP3MwkaPBU4SQA88T3qe
 mc ls env0/bucket-0
 mc share download env0/bucket-0/379_1661761509.mp4

 mc alias set env0-r https://tenant0.minio.env0.luojm.com:9443 readonly ccccc123
 mc share download env0-r/bucket-0/379_1661761509.mp4


mc alias set env0-zhihua https://tenant0.minio.env0.luojm.com:9443 zhihua ccccc123
mc rm --recursive --force env0-zhihua/fuan-up/zhihua/test
mc cp env0-zhihua/fuan-up/zhihua/VID_20211016_181807.mp4 ./1.mp4
mc cp ./1.mp4 env0-zhihua/fuan-up/zhihua/1.mp4


## cassandra

kubectl config set-context --current --namespace k8ssandra-operator
kubectl describe k8cs cassandra-cluster-env0 -n k8ssandra-operator

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