output "cloudfront_url" {
  description = "URL of the CloudFront distribution."
  value = "https://${aws_cloudfront_distribution.main.domain_name}" 
}