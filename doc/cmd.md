
# cmd

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