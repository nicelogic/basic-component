
# cockroach db

## cmd

cockroach start-single-node --insecure --listen-addr=localhost

### k8s

kubectl config set-context --current --namespace cockroach-operator-system
kubectl exec -it cockroachdb-client-secure -- ./cockroach sql --certs-dir=/cockroach/cockroach-certs --host=cockroachdb-public

CREATE USER luojm WITH PASSWORD 'xxx';
GRANT admin TO luojm;


cockroach sql --url 'postgres://luojm:xxx@192.168.1.104:26257?sslmode=verify-ca&sslrootcert=certs/ca.crt'     


## server less

nicelogic
aaB7XEjsDCNA1kA_-kCVeA