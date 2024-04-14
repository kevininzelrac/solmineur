variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Environment of the application"
  type        = string
  default = "qa"
}

variable "my_ip" {
  description = "My IP address"
  type        = string 
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}