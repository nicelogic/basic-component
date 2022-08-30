#!/bin/bash

# ssh root@$targetHost 'bash -s' < remote-deploy.sh

targetHost="192.168.1.201"
ssh root@$targetHost "mkdir -p /root/minio"

cd ../plugin
# wget https://gitee.com/wzhccccc123/file/blob/master/kubectl-minio -O kubectl-minio
wget https://github.com/minio/operator/releases/download/v4.4.16/kubectl-minio_4.4.16_linux_amd64 -O kubectl-minio
scp ./kubectl-minio root@$targetHost:/root/minio
cd ../script

ssh root@$targetHost "chmod +x /root/minio/kubectl-minio"
ssh root@$targetHost "mv /root/minio/kubectl-minio /usr/local/bin/"
ssh root@$targetHost "kubectl minio version"



