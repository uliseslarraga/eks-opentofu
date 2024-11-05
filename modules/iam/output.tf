output "cluster_rol_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "cluster_ng_rol_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}