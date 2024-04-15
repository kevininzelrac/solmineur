data "aws_caller_identity" "current" {}

module "QA"{
    source = "./modules/qa" 
    aws_region = var.aws_region
    app_name = var.app_name
    my_ip = var.my_ip
    account_id = data.aws_caller_identity.current.account_id
    db_username = var.db_username
    db_password = var.db_password
}

module "prod"{
    source = "./modules/prod" 
    aws_region = var.aws_region
    app_name = var.app_name
    domain_name = var.domain_name
    my_ip = var.my_ip
    account_id = data.aws_caller_identity.current.account_id
    aws_profile = var.aws_profile
    db_username = var.db_username
    db_password = var.db_password
 }
