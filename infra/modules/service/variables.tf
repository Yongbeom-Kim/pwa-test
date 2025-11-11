variable "environment" {
  type = string
  description = "Environment of the application. Must be one of: 'staging' or 'prod'."
  validation {
    condition     = contains(["staging", "prod"], var.environment)
    error_message = "The environment must be either 'staging' or 'prod'."
  }
}

variable "base_domain" {
  type = string
  description = "Base domain for the website. If your website is site.example.com, the base domain is example.com"
}

variable "full_domain" {
  type = string
  description = "Full domain for the website. If your website is site.example.com, the full domain is site.example.com"
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function."
}

variable "lambda_image_uri" {
  type        = string
  description = "The URI of the Lambda function image."
}

variable "cloudfront_cache_policy_name" {
  type = string
  description = "Name of the CloudFront cache policy for the website."
}