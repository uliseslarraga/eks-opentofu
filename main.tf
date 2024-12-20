module "network" {
    source      = "./modules/network"
    vpc_cidr    = var.vpc_cidr
    environment = var.environment
    tags        = var.tags
}

module "bastion" {
    source           = "./modules/bastionhost"
    vpc_id           = module.network.vpc_id
    environment      = var.environment
    public_subnet_id = module.network.pub_subnet_ids[0]
}

module "iam" {
    source            = "./modules/iam"
    oidc_provider_arn = module.eks.oidc_provider_arn
    oidc_provider_url = module.eks.oidc_provider_url
    tags              = var.tags
    environment       = var.environment
}

module "eks" {
    source              = "./modules/eks"
    tags                = var.tags
    environment         = var.environment
    private_subnets     = module.network.priv_subnet_ids
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
    source                = "./modules/database"
    tags                  = var.tags
    environment           = var.environment
    vpc_id                = module.network.vpc_id
    private_data_subnets  = module.network.priv_data_subnet_ids
    private_subnets_cidrs = module.network.priv_subnet_cidrs
    bastionh_sg_id        = module.bastion.bastionh_sg_id
}

module "k8s" {
    source            = "./modules/k8s"
    tags              = var.tags
    environment       = var.environment
    aws_region        = var.aws_region
    cluster_name      = module.eks.cluster_name
    eks_role_irsa_arn = module.iam.eks_role_irsa_arn
    depends_on        = [module.eks]
}