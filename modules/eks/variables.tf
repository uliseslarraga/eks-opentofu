variable "tags" {
  type        = any
  description = "Common resource tags"
}

variable "environment" {
  type        = string
  description = "Env name"
}

variable "private_subnets" {
  type        = any
  description = "Private subnet ids"
}

variable "cluster_rol_arn" {
  type        = any
  description = "Cluster rol ARN for EKS cluster"
}

variable "node_role_arn" {
  type        = any
  description = "Node Group rol ARN for EKS cluster"
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