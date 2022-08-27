#!/bin/bash

targetHost="192.168.1.201"
ssh root@$targetHost "kubectl minio init"
# kubectl minio  init --cluster-domain minio.env0.luojm.com --kubeconfig ../devops/env-0/token/admin.conf 

