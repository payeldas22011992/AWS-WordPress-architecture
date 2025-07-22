resource "aws_wafv2_ip_set" "allow_global" {
  name               = "${var.name}-allow-global"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"

  addresses = ["0.0.0.0/0"]

  tags = {
    Name = "${var.name}-ip-set"
  }
}

resource "aws_wafv2_web_acl" "geo_acl" {
  name        = "${var.name}-waf"
  description = "Geo restriction for CloudFront"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }

  rule {
    name     = "block-unsupported-countries"
    priority = 0

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = var.blocked_countries
      }
    }

    visibility_config {
      sampled_requests_enabled = true
      cloudwatch_metrics_enabled = true
      metric_name = "geo-blocked"
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name}-geo"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.name}-waf"
  }
}

resource "aws_cloudfront_distribution" "cf" {
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_sslProtocols    = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.php"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "alb-origin"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  web_acl_id = aws_wafv2_web_acl.geo_acl.arn

  tags = {
    Name = "${var.name}-cloudfront"
  }
}
