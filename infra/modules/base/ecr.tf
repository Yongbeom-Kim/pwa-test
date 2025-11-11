resource "aws_ecr_repository" "backend_lambda" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "IMMUTABLE_WITH_EXCLUSION"

  image_tag_mutability_exclusion_filter {
    filter      = "latest*"
    filter_type = "WILDCARD"
  }
}

resource "aws_ecr_lifecycle_policy" "backend_lambda" {
  repository = aws_ecr_repository.backend_lambda.name
  policy = data.aws_ecr_lifecycle_policy_document.keep_last_3.json
}

data "aws_ecr_lifecycle_policy_document" "keep_last_3" {
  rule {
    priority = 1
    description = "Keep last 3 images"

    selection {
      tag_status = "tagged"
      count_type      = "imageCountMoreThan"
      count_number    = 3
      tag_pattern_list = ["*"]
    }

    action {
      type = "expire"
    }
  }
}
