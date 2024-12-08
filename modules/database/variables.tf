variable "tags" {
  type        = any
  description = "Common resource tags"
}

variable "environment" {
  type        = string
  description = "Env name"
}

variable "vpc_id" {
  type        = any
  description = "VPC Id"
}

variable "private_data_subnets" {
  type        = any
  description = "Private data subnet ids"
}

variable "private_subnets_cidrs" {
  type        = any
  description = "Private data subnet cidrs"
}
