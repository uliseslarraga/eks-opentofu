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