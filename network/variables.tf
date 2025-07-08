variable "aws_region" {
  description = "region name"
  type        = string
}

variable "tags" {
  type        = any
  description = "Common resource tags"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR to be used for the new VPC"
}