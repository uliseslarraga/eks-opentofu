# DO NOT INCLUDE ANY SENSITIVE VALUE
vpc_cidr         = "10.0.0.0/16"
aws_region       = "us-east-2"
environment      = "development"
tags             = {terraform_provisioned = true, env = "development", project = "eks-cluster-sample"}
desired_size    = 2
max_size        = 3
min_size        = 1