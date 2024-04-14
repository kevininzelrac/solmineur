output "qa_cloudfront_url" {
  value = module.QA.cloudfront_url
}

output "prod_cloudfront_url" {
  value = module.prod.cloudfront_url
}

output "prod_name_servers" {
  value = module.prod.name_servers
}