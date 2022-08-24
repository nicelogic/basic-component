
# dashboard

## cmd

kubectl delete middleware stripprefix-k8s -n default

## token 

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"

## self-signed certificate

openssl req -x509 \
            -sha256 -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=http://192-168-1-201.nip.io/C=CN/L=Fu Jian" \
            -keyout rootCA.key -out rootCA.crt 

