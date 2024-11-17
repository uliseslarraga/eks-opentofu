variable "aws_region" {
  description = "region name"
  type        = string
}

variable "cluster_name" {
  description = "Eks cluster name"
  type        = string
}

variable "tags" {
  type        = any
  description = "Common resource tags"
}

variable "environment" {
  type        = string
  description = "Env name"
}

variable "eks_role_irsa_arn" {
  type        = string
  description = "IAM Role for Kubernetes Service Account"
}