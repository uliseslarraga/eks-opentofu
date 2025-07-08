# DO NOT INCLUDE ANY SENSITIVE VALUE
vpc_cidr            = "10.0.0.0/16"
aws_region          = "us-east-2"
tags                = {terraform_provisioned = true,project = "eks-cluster-sample"}
desired_size        = 2
max_size            = 3
min_size            = 1
k8s_version         = "1.31"
k8s_nodegr_version  = "1.31"
vpc_cni_version     = "v1.19.2-eksbuild.5"
kube_proxy_version  = "v1.31.3-eksbuild.2"
coredns_version     = "v1.11.4-eksbuild.2"
create_bastion      = false
create_rds          = false