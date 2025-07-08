module "network" {
    source      = "../modules/network"
    vpc_cidr    = var.vpc_cidr
    environment = terraform.workspace
    tags        = merge({env = terraform.workspace}, var.tags) 
}