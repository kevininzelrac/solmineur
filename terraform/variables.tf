variable "aws_profile" {
  description = "AWS profile to use for all resources"
  type    = string
  default = "agnesinzelrac"
}
variable "aws_region" {
  description = "AWS region for all resources"
  type    = string
  default = "eu-west-3"
}

variable "app_name" {
  description = "Name of the application"
  type        = string
  default     = "solmineur" 
}

variable "domain_name" {
  description = "Name of the application"
  type        = string
  default     = "solmineur.com" 
}

variable my_ip {
  description = "developer's IP address"
  type        = string
  sensitive   = true
}

variable db_username {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable db_password {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}