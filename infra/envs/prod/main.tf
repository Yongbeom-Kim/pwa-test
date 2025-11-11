module "base" {
    source = "../../modules/base"
    environment = "prod"
    full_domain = "pwa.yongbeom.com"
    base_domain = "yongbeom.com"
    ecr_repository_name = "pwa-yongbeom-com"
}

output "ecr_repository_name" {
  value = "pwa-yongbeom-com"
  description = "The name of the ECR repository."
}

output "ecr_repository_url" {
  value = module.base.ecr_repository_url
  description = "The URL of the ECR repository."
}


variable "lambda_image_uri" {
  type = string
  description = "The URI of the Lambda function image."
}

module "service" {
    source = "../../modules/service"
    environment = "prod"
    base_domain = "yongbeom.com"
    full_domain = "pwa.yongbeom.com"
    lambda_function_name = "pwa-yongbeom-com"
    lambda_image_uri = var.lambda_image_uri
    cloudfront_cache_policy_name = "pwa-yongbeom-com-cache-policy-prod"
}

output "lambda_function_url" {
  value = module.service.lambda_function_url
  description = "The URL of the Lambda function."
}

output "cloudfront_distribution_id" {
  value = module.service.cloudfront_distribution_id
  description = "The ID of the CloudFront distribution."
}