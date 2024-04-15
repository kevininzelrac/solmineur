## CREATE AWS IAM ROLE
resource "aws_iam_role" "main" {
 name = "${var.app_name}-${var.environment}"
 assume_role_policy = jsonencode({
   Version  = "2012-10-17"
   Statement = [{
     Effect = "Allow"
     Action = "sts:AssumeRole"
     Principal  = {
       Service  = ["lambda.amazonaws.com", "monitoring.rds.amazonaws.com"]
     }
    }
   ]
 })
}