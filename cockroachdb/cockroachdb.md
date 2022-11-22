
# cockroach db

## cmd

cockroach start-single-node --insecure --listen-addr=localhost

### k8s

kubectl config set-context --current --namespace cockroach-operator-system
kubectl exec -it cockroachdb-client-secure -- ./cockroach sql --certs-dir=/cockroach/cockroach-certs --host=cockroachdb-public

CREATE USER luojm WITH PASSWORD 'xxx';
GRANT admin TO luojm;


cockroach sql --url 'postgres://luojm@crdb.env0.luojm.com:9080?sslmode=verify-ca&sslrootcert=/etc/app-0/cert/ca.crt'   

 cockroach workload init startrek 'postgres://luojm@crdb.env0.luojm.com:9080?sslmode=verify-ca&sslrootcert=certs/ca.crt'
 cockroach workload init bank 'postgres://luojm:xxx@crdb.env0.luojm.com:9080?sslmode=verify-ca&sslrootcert=certs/ca.crt'
 cockroach workload run bank 'postgres://luojm:xxx@crdb.env0.luojm.com:9080?sslmode=verify-ca&sslrootcert=certs/ca.crt' --duration 60s
 cockroach workload init movr 'postgres://luojm@crdb.env0.luojm.com:9080?sslmode=verify-ca&sslrootcert=certs/ca.crt'

## server less

nicelogic
aaB7XEjsDCNA1kA_-kCVeA