output "cloudfront_url" {
  description = "URL of the CloudFront distribution."
  value = "https://${aws_cloudfront_distribution.main.domain_name}" 
}

output "name_servers" {
  description = "The name servers for our zone"
  value       = aws_route53_zone.main.name_servers
}

output "postgres_endpoint" {
    description = "value of the RDS endpoint."
    value = aws_db_instance.postgres.endpoint
}

output "lambda_oac_note" {
    description = "don't forget"
    value = "to add lambda OAC in cloudfront origin while terraform don't cover this option"
}