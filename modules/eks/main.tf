resource "aws_eks_cluster" "cluster" {
  name                          = "eks-cluster-${var.environment}"
  role_arn                      = var.cluster_rol_arn
  tags                          = merge({Name = "cluster-${var.environment}"}, var.tags)
  vpc_config {
    subnet_ids = var.private_subnets
  }
  version = var.k8s_version
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "node-group-${var.environment}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  tags = merge({Name = "node-group-${var.environment}"}, var.tags)
  version         = var.k8s_nodegr_version
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
}