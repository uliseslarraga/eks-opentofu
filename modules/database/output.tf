output "cluster_endpoint" {
  value = aws_rds_cluster.default.endpoint
}

output "cluster_identifier" {
  value = aws_rds_cluster.default.id
}