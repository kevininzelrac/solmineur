data "aws_caller_identity" "current" {}

module "QA"{
 source = "./modules/qa" 
 aws_region = var.aws_region
 app_name = var.app_name
 my_ip = var.my_ip
 account_id = data.aws_caller_identity.current.account_id
}

module "prod"{
 source = "./modules/prod" 
 aws_region = var.aws_region
 app_name = var.app_name
 domain_name = var.domain_name
 my_ip = var.my_ip
 account_id = data.aws_caller_identity.current.account_id
 aws_profile = var.aws_profile
 }
