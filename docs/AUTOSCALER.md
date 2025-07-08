# Setup Cluster Autoscaler
[Back to main](../README.md)  
```shell
#Using Autodiscovery
$ helm install k8s-autoscaler autoscaler/cluster-autoscaler \
    -n kube-system \
    --set 'autoDiscovery.clusterName'=eks-cluster-development \
    --set 'awsRegion=us-east-2' \
    --set rbac.serviceAccount.create=false \
    --set rbac.serviceAccount.name=cluster-autoscaler-development
```