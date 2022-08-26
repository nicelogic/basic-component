#!/bin/bash

kubectl minio --kubeconfig ../devops/env-0/token/admin.conf init --cluster-domain env0.minio.luojm.com
