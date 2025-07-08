# Build EKS Cluster with Opentofu

## Requirements 
- AWS Account 
- AWS CLI
- 1.8.4 Opentofu
- Helm

## Deploying Network Layer

To deploy an instance of the network and compute resources, follow next steps:

1. First step is to verify which resources will be deployed

```shell
make plan env=development layer=network
```
Behind the scenes, the above command initialize tofu root module, create or select new workspace wit the given env name and runs a tofu plan with a proper terraform.tfvars file.

2. Deploy a new instance of the Network resources

```shell
make apply env=development layer=network
```
The above command will initialize directory if it was not initialized, create or select a workspace with given name and performing a tofu apply with autoapprove flag. 

## Deploying Compute Layer

1. First step is to verify which resources will be deployed

```shell
make plan env=development layer=compute
```

2. Deploy a new instance of the Network resources

```shell
make apply env=development layer=compute
```
If you get an error creating k8s Service accounts repeate step 2


## Other Resources
- [Install AWS Controller](docs/AWS-CONTROLLER.md)
- [Install Argo CD](docs/ARGOCD.md)
- [Install Cluster Autoscaler](docs/AUTOSCALER.md)
- [Configure RDS for K8s example](docs/db-setup.md)