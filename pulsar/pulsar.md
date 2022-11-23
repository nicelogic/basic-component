
# pulsar

CSRF_TOKEN=$(curl http://192.168.1.104:8080/pulsar-manager/csrf-token)
curl \
    -H "X-XSRF-TOKEN: $CSRF_TOKEN" \
    -H "Cookie: XSRF-TOKEN=$CSRF_TOKEN;" \
    -H 'Content-Type: application/json' \
    -X PUT http://192.168.1.104:8080/pulsar-manager/users/superuser \
    -d '{"name": "xxx", "password": "xxxxx", "description": "admin", "email": "358844436@qq.com"}'