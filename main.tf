module "network" {
    source      = "./modules/network"
    vpc_cidr    = var.vpc_cidr
    environment = var.environment
    tags        = var.tags
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

module "k8s" {
    source            = "./modules/k8s"
    tags              = var.tags
    environment       = var.environment
    eks_role_irsa_arn = module.iam.eks_role_irsa_arn
}