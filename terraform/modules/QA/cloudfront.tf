##CREATE ORIGIN ACCESS CONTROL
resource "aws_cloudfront_origin_access_control" "main" {
  name                              = aws_s3_bucket.assets.bucket_regional_domain_name
  description                       = aws_s3_bucket.assets.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

##CREATE CLOUDFRONT DISTRIBUTION
resource "aws_cloudfront_distribution" "main" {
    enabled             = true
    is_ipv6_enabled     = true
    comment             = "${var.app_name}-${var.environment}"
    price_class         = "PriceClass_All"
    http_version        = "http2"

    ##CREATE S3 ORIGIN
    origin {
        domain_name = aws_s3_bucket.assets.bucket_regional_domain_name
        origin_id   = "assets"

        s3_origin_config {
            origin_access_identity = ""
        }
        origin_access_control_id = aws_cloudfront_origin_access_control.main.id
    }

    ##CREATE LAMBDA ORIGIN
    origin {
        domain_name = replace(replace(aws_lambda_function_url.server.function_url, "https://", ""), "/", "")
        origin_id   = "lambda"

        custom_origin_config {
            http_port              = 80
            https_port             = 443
            origin_protocol_policy = "https-only"
            origin_ssl_protocols   = ["TLSv1.2"]
        }
    }

    ##CREATE DEFAULT CACHE BEHAVIOR
    default_cache_behavior {
        target_origin_id            = "lambda"
        compress                    = true
        viewer_protocol_policy      = "redirect-to-https"
        allowed_methods             = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods              = ["GET", "HEAD"]
        cache_policy_id             = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
        origin_request_policy_id    = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
        smooth_streaming            = false
    }

    ##CREATE ASSETS CACHE BEHAVIOR
    ordered_cache_behavior {
        path_pattern           = "assets/*"
        target_origin_id       = "assets"
        viewer_protocol_policy = "redirect-to-https"
        allowed_methods        = ["GET", "HEAD"]
        cached_methods         = ["GET", "HEAD"]
        compress               = true
        smooth_streaming       = false
        cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    }
    
    ##CREATE FAVICON CACHE BEHAVIOR
    ordered_cache_behavior {
        path_pattern            = "/favicon.ico"
        target_origin_id        = "assets"
        viewer_protocol_policy  = "redirect-to-https"
        allowed_methods         = ["GET", "HEAD"]
        cached_methods          = ["GET", "HEAD"]
        compress                = true
        smooth_streaming        = false
        cache_policy_id         = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
}
