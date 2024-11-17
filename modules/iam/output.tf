output "cluster_rol_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_role_irsa_arn" {
  value = aws_iam_role.eks_role_irsa.arn
}

output "cluster_ng_rol_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "cluster_rol_name" {
  value = aws_iam_role.eks_cluster_role.name
}

output "aws_lb_controller_policy_arn" {
  value = aws_iam_policy.aws_lb_controller_policy.arn
}