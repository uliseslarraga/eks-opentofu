module "network" {
    source      = "./modules/network"
    vpc_cidr    = var.vpc_cidr
    environment = var.environment
    tags        = var.tags
}

module "iam" {
    source           = "./modules/iam"
    tags             = var.tags
    environment      = var.environment
}

module "eks" {
    source           = "./modules/eks"
    tags             = var.tags
    environment      = var.environment
    #vpc_id           = module.network.vpc_id
    private_subnets  = module.network.priv_subnet_ids
    cluster_rol_arn  = module.iam.cluster_rol_arn
    node_role_arn    = module.iam.cluster_ng_rol_arn
    desired_size     = var.desired_size
    max_size         = var.max_size
    min_size         = var.min_size
}