# Build EKS Cluster with Opentofu

## Requirements 
- AWS Account 
- AWS CLI
- 1.8.4 Opentofu

## Deploying an infra instance

To deploy an instance of the AWS Infra, follow next steps:

1. Initialize the directory with the flag **_--backend-config_** to chose over the different terraform state files, each subfolder corresponds to one environment, the different files are stored in **env** folder
```
tofu init -backend-config=env/<env>/backend.hcl
```

2. Verify the deployed resources with terraform plan command indicating which tf variable file you will use (it should be different for each environent)

```
tofu plan -var-file="./env/<env>/dev.auto.tfvars"
```

3. Deploy a new instance of the App

```
tofu apply -var-file="./env/<env>/dev.auto.tfvars"
```
4. Create Kubeconfig file
```
aws eks update-kubeconfig --name $(tofu output -raw -var-file="./env/dev/dev.auto.tfvars" cluster_name)
```

## Install AWS Controller

There is a value.yml file with values to deploy an AWS controller with helm:

```
$ helm repo add eks https://aws.github.io/eks-charts

$ helm repo update eks

$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --values k8s/aws-controller/values-dev.yml
```