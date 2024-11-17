#EKS IAM items
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  force_detach_policies = false
  max_session_duration  = 3600
  path                  = "/"
  tags = {
    "Name" = "AmazonEKSLoadBalancerControllerRole_${var.environment}"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

#Node Group IAM Items
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy" "aws_lb_controller_policy" {
  name        = "AWSLoadBalancerControllerIAMPolicy_${var.environment}"
  path        = "/"
  description = "AWS LoadBalancer Controller IAM Policy"

  policy = file("${path.module}/policies/iam_policy_lbc.json")
}

resource "aws_iam_role" "eks_role_irsa" {
  name = "eks-irsa-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Sid    = ""
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
            "${var.oidc_provider_url}:sub" = "system:serviceaccount:default:my-service-account"
            "${var.oidc_provider_url}:aud" = "sts.amazonaws.com"
          }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks-controller-policy-attach" {
  role       = aws_iam_role.eks_role_irsa.name
  policy_arn = aws_iam_policy.aws_lb_controller_policy.arn
}