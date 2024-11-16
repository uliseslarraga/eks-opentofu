variable "aws_region" {
  description = "region name"
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

variable "vpc_cidr" {
  type        = string
  description = "CIDR to be used for the new VPC"
}

variable "desired_size" {
  type        = any
  description = "Desired size of node group"
}

variable "max_size" {
  type        = any
  description = "Max size of node group"
}

variable "min_size" {
  type        = any
  description = "Min size of node group"
}

variable "k8s_version" {
  type        = any
  description = "Kubernetes version configured on EKS cluster"
}

variable "k8s_nodegr_version" {
  type        = any
  description = "Kubernetes version configured on EKS Node group"
}

variable "vpc_cni_version" {
  type        = any
  description = "VPC CNI addon version"
}

variable "kube_proxy_version" {
  type        = any
  description = "kube-proxy addon version"
}

variable "coredns_version" {
  type        = any
  description = "Core DNS addon version"
}