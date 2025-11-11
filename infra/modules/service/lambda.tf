# # Variables for Lambda and ECR
# variable "backend_lambda_ecr_name" {
#   type        = string
#   description = "The name of the ECR repository for the backend lambda container."
# }

# IAM Role for Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.lambda_function_name}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy Attachment for Lambda Basic Execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_lambda_function" "backend" {
  function_name = var.lambda_function_name
  role         = aws_iam_role.lambda_execution_role.arn
  
  package_type = "Image"
  image_uri    = var.lambda_image_uri
  
  timeout = 30
  memory_size = 512

  environment {
    variables = {
      NODE_ENV = "production"
    }
  }
}

# Lambda Function URL (optional - for direct HTTP access)
resource "aws_lambda_function_url" "backend_url" {
  function_name      = aws_lambda_function.backend.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["date", "keep-alive"]
    max_age          = 86400
  }
}