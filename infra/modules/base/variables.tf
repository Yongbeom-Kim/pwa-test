variable "base_domain" {
  type = string
  description = "Base domain for the website. If your website is site.example.com, the base domain is example.com"
}

variable "full_domain" {
  type = string
  description = "Full domain for the website. If your website is site.example.com, the full domain is site.example.com"
}

variable "ecr_repository_name" {
  type = string
  description = "Name of the ECR repository."
}

variable "environment" {
  type        = string
  description = "Environment of the application. Must be one of: 'staging' or 'prod'."
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "The environment must be either 'staging' or 'prod'."
  }
}