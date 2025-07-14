variable "tags" {
  type        = any
  description = "Common resource tags"
}

variable "cluster_name" {
  description = "Eks cluster name"
  type        = string
}

variable "environment" {
  type        = string
  description = "Env name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "OIDC provider arn"
}

variable "oidc_provider_url" {
  type        = string
  description = "OIDC provider url"
}

variable "worker_nodes_arn" {
  type        = string
  description = "Worker nodes group arn"
}