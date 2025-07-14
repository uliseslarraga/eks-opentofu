resource "aws_eks_cluster" "cluster" {
  name                          = "eks-cluster-${var.environment}"
  role_arn                      = var.cluster_rol_arn
  tags                          = merge({Name = "cluster-${var.environment}"}, var.tags)
  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
  vpc_config {
    subnet_ids = var.private_subnets
    security_group_ids = [aws_security_group.worker_nodes.id]
  }
  version = var.k8s_version
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "node-group-${var.environment}"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnets
  tags = merge(
    {
      Name = "node-group-${var.environment}", 
      "k8s.io/cluster-autoscaler/enabled"="true",
      "k8s.io/cluster-autoscaler/${aws_eks_cluster.cluster.name}"="owned"
    }, var.tags)
  version         = var.k8s_nodegr_version
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }
}

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "20.36.0"

  cluster_name                    = aws_eks_cluster.cluster.name
  enable_pod_identity             = true
  create_pod_identity_association = true
  namespace                       = "karpenter"
  iam_role_name                   = "${aws_eks_cluster.cluster.name}-karpenter-controller"
  iam_role_use_name_prefix        = false
  iam_policy_name                 = "${aws_eks_cluster.cluster.name}-karpenter-controller"
  iam_policy_use_name_prefix      = false
  node_iam_role_name              = "${aws_eks_cluster.cluster.name}-karpenter-node"
  node_iam_role_use_name_prefix   = false
  queue_name                      = "${aws_eks_cluster.cluster.name}-karpenter"
  rule_name_prefix                = "eks-cluster-sample"

  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = var.tags

}