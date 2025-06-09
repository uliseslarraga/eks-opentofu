terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "tf-backend-ulr-2024-02-05"
    key            = "compute/terraform.tfstate"
    region         = "us-east-1"
    workspace_key_prefix  = "environment"
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-2"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}