data "aws_route53_zone" "main" {
  name = var.base_domain
}

resource "aws_route53_record" "website_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.full_domain
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = true
  }
}