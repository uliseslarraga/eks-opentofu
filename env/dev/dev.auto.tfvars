# DO NOT INCLUDE ANY SENSITIVE VALUE
vpc_cidr            = "10.0.0.0/16"
aws_region          = "us-east-2"
environment         = "development"
tags                = {terraform_provisioned = true, env = "development", project = "eks-cluster-sample"}
desired_size        = 2
max_size            = 3
min_size            = 1
k8s_version         = "1.29"
vpc_cni_version     = "v1.18.6-eksbuild.1"
kube_proxy_version  = "v1.29.9-eksbuild.1"
coredns_version     = "v1.11.3-eksbuild.2"