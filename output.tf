output "cluster_name" {
    value = module.eks.cluster_name
}

output "cluster_endpoint" {
    value = module.eks.cluster_endpoint
}

output "rds_endpoint" {
    value = module.database.cluster_endpoint
}

output "rds_identifier" {
    value = module.database.cluster_identifier
}