output "vpc_id" {
    value = module.network.vpc_id
}

output "pub_subnet_cidrs" {
    value = module.network.pub_subnet_cidrs
}

output "pub_subnet_ids" {
    value = module.network.pub_subnet_ids
}

output "priv_subnet_cidrs" {
  value = module.network.priv_subnet_cidrs
}

output "priv_subnet_ids" {
  value = module.network.priv_subnet_ids
}

output "priv_data_subnet_cidrs" {
  value = module.network.priv_data_subnet_cidrs
}

output "priv_data_subnet_ids" {
  value = module.network.priv_data_subnet_ids
}