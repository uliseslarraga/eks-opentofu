layer=$(layer)
env=$(env)
VPC_ID := $(shell cd network && tofu output -raw vpc_id) 

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

KARPENTER_VERSION="1.5.2"
KARPENTER_NAMESPACE = "karpenter"
AWS_PARTITION="aws"
AWS_REGION="us-east-2"
CLUSTER_NAME := $(strip $(shell cd compute && tofu output -raw cluster_name))
K8S_VERSION := $(strip $(shell aws eks describe-cluster --name "$(CLUSTER_NAME)" --query "cluster.version" --output text))
AWS_ACCOUNT_ID := $(shell aws sts get-caller-identity --query 'Account' --output text)
#CLUSTER_NAME := $(strip ${CLUSTER_NAME})
NODE_GROUP := $(shell aws eks list-nodegroups --cluster-name $(CLUSTER_NAME) --query 'nodegroups[0]' --output text)
#Default security group for EKS ctrl plane
SECURITY_GROUPS := $(shell aws eks describe-cluster --name $(CLUSTER_NAME) --query "cluster.resourcesVpcConfig.clusterSecurityGroupId" --output text)
ALIAS_VERSION := $(shell aws ssm get-parameter --name "/aws/service/eks/optimized-ami/$(K8S_VERSION)/amazon-linux-2023/x86_64/standard/recommended/image_id" --query Parameter.Value --output text | xargs aws ec2 describe-images --query 'Images[0].Name' --image-ids | grep -o 'v[0-9]\+')


karpenter-prereq:
	@echo "Installing Karpenter for AWS EKS"
	@echo "${KARPENTER_NAMESPACE} ${CLUSTER_NAME} ${NODE_GROUP} ${ALIAS_VERSION}"
	aws ec2 create-tags \
    --tags "Key=karpenter.sh/discovery,Value=${CLUSTER_NAME}" \
    --resources "${SECURITY_GROUPS}"

create-karpenter-manifest:
	helm template karpenter oci://public.ecr.aws/karpenter/karpenter --version "${KARPENTER_VERSION}" --namespace "${KARPENTER_NAMESPACE}" \
		--set "settings.clusterName=$(strip ${CLUSTER_NAME})" \
		--set "settings.interruptionQueue=$(strip ${CLUSTER_NAME})-karpenter" \
		--set "serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:${AWS_PARTITION}:iam::${AWS_ACCOUNT_ID}:role/$(strip ${CLUSTER_NAME})-karpenter-node" \
		--set controller.resources.requests.cpu=1 \
		--set controller.resources.requests.memory=1Gi \
		--set controller.resources.limits.cpu=1 \
		--set controller.resources.limits.memory=1Gi > karpenter.yaml

create-crds-and-deploy-karpenter:
	kubectl create namespace "${KARPENTER_NAMESPACE}" || true
	kubectl create -f \
    	"https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/pkg/apis/crds/karpenter.sh_nodepools.yaml"
	kubectl create -f \
    	"https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/pkg/apis/crds/karpenter.k8s.aws_ec2nodeclasses.yaml"
	kubectl create -f \
    	"https://raw.githubusercontent.com/aws/karpenter-provider-aws/v${KARPENTER_VERSION}/pkg/apis/crds/karpenter.sh_nodeclaims.yaml"
	kubectl apply -f karpenter.yaml

create-nodeclass-and-nodepool:
	@echo "${KARPENTER_NAMESPACE} ${CLUSTER_NAME} ${NODE_GROUP} ${K8S_VERSION} ${ALIAS_VERSION}" 
	CLUSTER_NAME=$(CLUSTER_NAME) ALIAS_VERSION=$(ALIAS_VERSION) ./scripts/create-node-pool.sh
