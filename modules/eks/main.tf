resource "aws_eks_cluster" "eks_cluster" {
  name     = "eks-cluster-${var.environment}"
  role_arn = var.cluster_rol_arn
  tags = merge({Name = "eks-cluster-${var.environment}"}, var.tags)
  vpc_config {
    subnet_ids = var.private_subnets
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node-group-${var.environment}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  tags = merge({Name = "eks-node-group-${var.environment}"}, var.tags)
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
}