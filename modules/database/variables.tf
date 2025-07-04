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

variable "bastionh_sg_id" {
  type        = any
  description = "Security group id to allow traffic from bastion host instance"
}

variable "worker_nodes_sg_id" {
  type        = any
  description = "Security group id to allow traffic from bastion host instance"
}