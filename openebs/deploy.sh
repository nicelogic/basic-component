#!/bin/bash


#kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
#kubectl delete -f https://openebs.github.io/charts/openebs-operator.yaml

kubeConfigFilePath=$(cat ../0-env/which-env-to-apply)
echo "current env: $kubeConfigFilePath"

targetHost="192.168.1.201"
ssh root@$targetHost "sudo systemctl enable --now iscsid"
ssh root@$targetHost "mkdir -p /opt/data/openebs/local"

kubectl --kubeconfig $kubeConfigFilePath apply -f https://openebs.github.io/charts/openebs-operator-lite.yaml 
kubectl --kubeconfig $kubeConfigFilePath apply -f https://openebs.github.io/charts/openebs-lite-sc.yaml
kubectl --kubeconfig $kubeConfigFilePath apply -k ./k8s