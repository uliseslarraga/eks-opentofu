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

## Install AWS Controller

There is a value.yml file with values to deploy an AWS controller with helm:

```shell
$ helm repo add eks https://aws.github.io/eks-charts

$ helm repo update eks

$ helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    -n kube-system \
    --values k8s/aws-controller/values-dev.yml \
    --set vpcId=$VPC_ID,region=us-east-2 \
    --version 1.13.3
```

## Deploy a demo example to validate AWS Controller

```shell
$ k apply -f k8s/sample_app/demo.yml

$ export DEMO_APP_URL=$(kubectl get ingress/ingress-2048 -n game-2048 -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

$ echo "Game 2048 URL: http://$DEMO_APP_URL"

```

## Install ArgoCD
There is a preconfigured values.yaml file for argocd deploy with helm:
```shell
#Add argocd repo
helm repo add argo-cd https://argoproj.github.io/argo-helm

#install argocd
helm upgrade --install argocd argo-cd/argo-cd --version 8.1.2 \
  --namespace "argocd" --create-namespace \
  --values k8s/argocd/values.yaml \
  --wait

#Get argocd URL
export ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o json | jq --raw-output '.status.loadBalancer.ingress[0].hostname')
echo "ArgoCD URL: https://$ARGOCD_SERVER"

#Get Argocd password for admin user
export ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD admin password: $ARGOCD_PWD"

#Login with argocli
argocd login $ARGOCD_SERVER --username admin --password $ARGOCD_PWD --insecure
```

## RDS Setup
To load the sample data into the RDS sql, you should log in into bastion host with cmd psql client, you need to install psql client on ec2 with this command

```shell
$ sudo yum install postgresql15
```

Create a file with your favorite text editor (vim, nano, etc.) copy the content of the file db/db.sql and paste it into a file called db.sql

```shell
$ vim db.sql
$ psql -h <your-rds-endpoint> -p 5432 --dbname=products --username=java_app -a -f db.sql
```
The above command will promp a password input, you should be able to log in with the password set on your tofu script for the database module.