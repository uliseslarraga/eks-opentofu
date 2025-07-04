module "bastion" {
    source           = "../modules/bastionhost"
    vpc_id           = data.terraform_remote_state.networking.outputs.vpc_id
    environment      = var.environment
    public_subnet_id = data.terraform_remote_state.networking.outputs.pub_subnet_ids[0]
}

module "iam" {
    source            = "../modules/iam"
    oidc_provider_arn = module.eks.oidc_provider_arn
    oidc_provider_url = module.eks.oidc_provider_url
    tags              = merge({env = terraform.workspace}, var.tags) 
    environment       = var.environment
}

module "eks" {
    source              = "../modules/eks"
    tags                = merge({env = terraform.workspace}, var.tags) 
    environment         = var.environment
    vpc_id              = data.terraform_remote_state.networking.outputs.vpc_id
    private_subnets     = data.terraform_remote_state.networking.outputs.priv_subnet_ids
    cluster_rol_arn     = module.iam.cluster_rol_arn
    node_role_arn       = module.iam.cluster_ng_rol_arn
    desired_size        = var.desired_size
    max_size            = var.max_size
    min_size            = var.min_size
    k8s_version         = var.k8s_version
    k8s_nodegr_version  = var.k8s_nodegr_version
    vpc_cni_version     = var.vpc_cni_version
    kube_proxy_version  = var.kube_proxy_version
    coredns_version     = var.coredns_version
}

module "database" {
    source                = "../modules/database"
    tags                  = merge({env = terraform.workspace}, var.tags) 
    environment           = var.environment
    vpc_id                = data.terraform_remote_state.networking.outputs.vpc_id
    private_data_subnets  = data.terraform_remote_state.networking.outputs.priv_data_subnet_ids
    private_subnets_cidrs = data.terraform_remote_state.networking.outputs.priv_subnet_cidrs
    bastionh_sg_id        = module.bastion.bastionh_sg_id
    worker_nodes_sg_id    = module.eks.worker_nodes_sg_id
}

module "k8s" {
    source                      = "../modules/k8s"
    tags                        = merge({env = terraform.workspace}, var.tags) 
    environment                 = var.environment
    aws_region                  = var.aws_region
    cluster_name                = module.eks.cluster_name
    eks_role_irsa_arn           = module.iam.eks_role_irsa_arn
    autoscaler_role_irsa_arn    = module.iam.autoscaler_role_irsa_arn
    depends_on                  = [module.eks]
}