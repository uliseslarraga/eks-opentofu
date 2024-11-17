variable "tags" {
  type        = any
  description = "Common resource tags"
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