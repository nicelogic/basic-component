#!/bin/bash

cd ./plugin
wget https://gitee.com/wzhccccc123/file/blob/master/kubectl-minio -O kubectl-minio
cd ..
scp ./plugin/
ssh root@192.168.1.101 'bash -s' < remote-deploy.sh