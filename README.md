# Build EKS Cluster with Opentofu

## Requirements 
- AWS Account 
- AWS CLI
- 1.8.4 Opentofu

## Deploying an infra instance

To deploy an instance of the network and compute resources, follow next steps:

1. Navigate into network folder and Initialize the directory 

```shell
cd network
tofu init -backend-config=env/<env>/backend.hcl
```

2. Create tofu workspace

```shell
tofu workspace new development
```

3. Verify the deployed resources with terraform plan command indicating which tf variable file you will use (it should be different for each environent)

```shell
tofu plan -var-file="../env/<env>/terraform.tfvars"
```

4. Deploy a new instance of the Network resources

```shell
tofu apply -var-file="./env/<env>/terraform.tfvars"
```

5. Navigate into compute folder and Initialize the directory

```shell
cd compute
tofu init -backend-config=env/<env>/backend.hcl
```
After initializing compute module repeat steps 2 to 4

6. Create Kubeconfig file
```shell
aws eks update-kubeconfig --name $(tofu output -raw -var-file="./env/dev/dev.auto.tfvars" cluster_name)
```

7. Other Resources
- [Install AWS Controller](docs/AWS-CONTROLLER.md)
- [Install Argo CD](docs/ARGOCD.md)
- [Install Cluster Autoscaler](docs/AUTOSCALER.md)
- [Configure RDS for K8s example](docs/db-setup.md)