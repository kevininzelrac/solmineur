output "qa_cloudfront_url" {
  value = module.QA.cloudfront_url
}

output "qa_postgres_endpoint" {
  value = module.QA.postgres_endpoint
}

output "QA_lambda_oac_note" {
  value = module.QA.lambda_oac_note 
}

output "prod_cloudfront_url" {
  value = module.prod.cloudfront_url
}

output "prod_name_servers" {
  value = module.prod.name_servers
}

output "prod_postgres_endpoint" {
  value = module.prod.postgres_endpoint
}

output "prod_lambda_oac_note" {
  value = module.prod.lambda_oac_note 
}