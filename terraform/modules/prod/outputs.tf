output "cloudfront_url" {
  description = "URL of the CloudFront distribution."
  value = "https://${aws_cloudfront_distribution.main.domain_name}" 
}

output "name_servers" {
  description = "The name servers for our zone"
  value       = aws_route53_zone.main.name_servers
}