module "network" {
    source      = "../modules/network"
    vpc_cidr    = var.vpc_cidr
    environment = var.environment
    tags        = merge({env = terraform.workspace}, var.tags) 
}