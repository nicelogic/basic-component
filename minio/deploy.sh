#!/bin/bash

cd script
./install-kubectl-minio-to-host.sh
./init-minio-k8s-operator.sh
cd ..

