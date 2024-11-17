resource "kubernetes_service_account" "k8s_sa_controller" {
  metadata {
    name      = "aws-load-balancer-controller-${var.environment}"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = var.eks_role_irsa_arn
    }
  }
}