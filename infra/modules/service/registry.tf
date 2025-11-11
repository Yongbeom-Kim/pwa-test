terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

  default_tags {
    tags = {
      managed_by = "OpenTofu"
      application = "personal-blog"
      environment = var.environment
    }
  }
}