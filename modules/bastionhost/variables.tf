# EC2 Bastion Host variables
variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type        = any
  description = "Private data subnet ids"
}