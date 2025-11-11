data "aws_acm_certificate" "cert" {
  domain = var.full_domain
}

locals {
  cloudfront_origin_id    = "origin-${var.full_domain}"
  lambda_function_domain  = replace(replace(aws_lambda_function_url.backend_url.function_url, "https://", ""), "/", "")
}

resource "aws_cloudfront_distribution" "frontend" {
  origin {
    domain_name = local.lambda_function_domain
    origin_id   = local.cloudfront_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled      = true
  http_version = "http2"

  default_cache_behavior {
    target_origin_id       = local.cloudfront_origin_id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    # use our no-cache policy
    cache_policy_id = aws_cloudfront_cache_policy.no_cache.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.all_to_origin.id


    compress = true
  }

  price_class = "PriceClass_200"
  aliases     = ["${var.full_domain}", "www.${var.full_domain}"]

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

# new: no-cache policy
resource "aws_cloudfront_cache_policy" "no_cache" {
  name        = "${var.cloudfront_cache_policy_name}-no-cache"
  min_ttl     = 0
  default_ttl = 0
  max_ttl     = 0

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}



resource "aws_cloudfront_origin_request_policy" "all_to_origin" {
  name = "${var.cloudfront_cache_policy_name}-all-to-origin"

  cookies_config {
    cookie_behavior = "all"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
      "Accept",
      "Accept-Language",
      "Origin",
      "User-Agent",
      "Referer",
      ]
    }
  }
  query_strings_config {
    query_string_behavior = "all"
  }
}