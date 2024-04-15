## GET DEFAULT VPC
data "aws_vpc" "default" {
  default = true
}

## GET DEFAULT SUBNET LIST
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

## CREATE SECURITY GROUP FOR POSTGRES
resource "aws_security_group" "postgres" {
  name        = "${var.app_name}-${var.environment}-postgres"
  description = "Security group for ${var.app_name}-${var.environment}-postgres db instance"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow traffic from my IP address to postgres db instance"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    description = "Allow traffic from the security group itself to postgres db instance"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    self        = true
  }

  egress {
    description = "Allow traffic from the security group itself to postgres db instance"
    from_port   = "5432"
    to_port     = "5432"
    protocol    = "tcp"
    self        = true
  }

  lifecycle {
    create_before_destroy = true
  }
}