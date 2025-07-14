locals {
  cni_config = "${path.module}/addon-config"
}


resource "aws_eks_addon" "vpc-cni" {
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group
  ]
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "vpc-cni"
  resolve_conflicts_on_create = "OVERWRITE"
  configuration_values = file("${local.cni_config}/cni.json")
  addon_version        = var.vpc_cni_version
  preserve = true

}

resource "aws_eks_addon" "core-dns" {
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group
  ]
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "coredns"
  resolve_conflicts_on_create = "OVERWRITE"
  configuration_values = file("${local.cni_config}/coredns.json")
  addon_version        = var.coredns_version
  preserve = true
}

resource "aws_eks_addon" "kube-proxy" {
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group
  ]
  cluster_name      = aws_eks_cluster.cluster.name
  addon_name        = "kube-proxy"
  resolve_conflicts_on_create = "OVERWRITE"
  addon_version        = var.kube_proxy_version
  preserve = true

}

resource "aws_eks_addon" "pod_identity" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_create = "OVERWRITE"
  preserve                    = false
}