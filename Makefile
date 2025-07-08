layer=$(layer)
env=$(env)
VPC_ID := $(shell cd $(layer) && tofu output -raw vpc_id) 

validate_workspace:
	cd $(layer); \
	tofu workspace select -or-create $(env)

init:
	@echo "Initializing layer with tofu init over $(layer) in $(env) environment"
	cd $(layer); \
	tofu init

destroy: validate_workspace
	@echo "Destroying $(layer) in $(env) environment"
	cd $(layer); \
	tofu destroy -var-file=../env/${env}/terraform.tfvars

plan: init validate_workspace
	@echo "Performing tofu plan over $(layer) in $(env) environment"
	cd $(layer); \
	tofu plan -var-file=../env/${env}/terraform.tfvars

apply: validate_workspace
	@echo "Performing tofu apply over $(layer) in $(env) environment "
	cd $(layer); \
	tofu apply -var-file=../env/${env}/terraform.tfvars -auto-approve

aws-controller-install:
	#TODO: Add service account name and cluster name as variables
	@echo "Installing AWS Controller for Kubernetes"
	@echo "Configured VPC ID: $(VPC_ID)"
	helm repo add eks https://aws.github.io/eks-charts
	helm repo update eks
	helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
    	-n kube-system \
    	--values k8s/aws-controller/values-dev.yml \
    	--set vpcId=$(strip $(VPC_ID)) \
		--set region=us-east-2 \
    	--version 1.13.3

cluster-as-install:
	@echo "Installing Cluster Autoscaler for Kubernetes"
