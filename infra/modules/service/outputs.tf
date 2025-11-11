output "cloudfront_distribution_id" {
    value = aws_cloudfront_distribution.frontend.id
    description = "The ID of the CloudFront distribution. Used to invalidate the cache."
}

output "lambda_function_url" {
    value = aws_lambda_function_url.backend_url.function_url
    description = "The URL of the Lambda function."
}