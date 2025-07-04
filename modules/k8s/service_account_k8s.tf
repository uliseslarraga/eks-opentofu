resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.cluster_name}"
    }
}

resource "kubernetes_service_account" "k8s_sa_controller" {
  metadata {
    name        = "aws-load-balancer-controller-${var.environment}"
    namespace   = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.eks_role_irsa_arn
    }
  }
  depends_on    = [null_resource.kubectl]
}

resource "kubernetes_service_account" "k8s_sa_autoscaler" {
  metadata {
    name        = "cluster-autoscaler-${var.environment}"
    namespace   = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.autoscaler_role_irsa_arn
    }
  }
  depends_on    = [null_resource.kubectl]
}