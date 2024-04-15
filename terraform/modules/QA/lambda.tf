## CREATE function.zip
data "archive_file" "lambda_zip" {
  type = "zip"
  source {
    filename = "index.mjs"
    content = "export const handler = async () => ({statusCode: 200, body: 'Hello World'})"
  }
  output_path = "modules/${var.environment}/function.zip"
}

## CREATE S3 BUCKET TO STORE LAMBDA FUNCTION
resource "aws_s3_bucket" "lambda" {
    bucket = "${var.app_name}-${var.environment}-lambda"
    force_destroy = true
}

## UPLOAD ZIP TO S3 BUCKET
resource "aws_s3_object" "function_zip" {
    bucket = aws_s3_bucket.lambda.id
    key    = "function.zip"
    source = data.archive_file.lambda_zip.output_path
    acl    = "private"
}

## GRANT PERMISSIONS TO LAMBDA FUNCTION TO ACCESS THE BUCKET
resource "aws_lambda_permission" "s3_access" {
    statement_id  = "AllowS3Access"
    action        = "lambda:GetObject"
    function_name = aws_lambda_function.server.function_name
    principal     = "s3.amazonaws.com"
    source_arn    = aws_s3_bucket.lambda.arn
}

## GRANT PERMISSIONS TO CLOUDFRONT TO ACCESS LAMBDA FUNCTION
resource "aws_lambda_permission" "cloudfront" {
    statement_id  = "AllowCloudFrontAccess"
    action        = "lambda:InvokeFunctionUrl"
    function_name = aws_lambda_function.server.function_name
    principal     = "cloudfront.amazonaws.com"
    source_arn    = aws_cloudfront_distribution.main.arn
}

## CREATE LAMBDA CLOUDWATCH LOGS POLICY
resource "aws_iam_role_policy" "cloudWatchLogs" {
  name = "cloudWatchLogs"
  role = aws_iam_role.main.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow",
        Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
        Resource = "arn:aws:logs:*:*:log-group:/aws/lambda/${aws_lambda_function.server.function_name }:*"      
      }]
  })
}

##CREATE LAMBDA VPC POLICY
resource "aws_iam_role_policy" "vpcAccess" {
  name = "createNetworkInterface"
  role = aws_iam_role.main.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
        Effect = "Allow",
        Action = [
                "ec2:CreateNetworkInterface",
                "ec2:DeleteNetworkInterface",
                "ec2:DescribeNetworkInterfaces"
            ],
        Resource = "*"
        }]
  })
}

## CREATE LAMBDA FUNCTION W/ function.zip
resource "aws_lambda_function" "server" {
  function_name     = "${var.app_name}-${var.environment}"
  description       = "${var.app_name}-${var.environment}"
  role              = aws_iam_role.main.arn
  #filename          = data.archive_file.lambda_zip.output_path
  #source_code_hash  = data.archive_file.lambda_zip.output_base64sha256
  s3_bucket         =  aws_s3_bucket.lambda.id
  s3_key            =  aws_s3_object.function_zip.key
  architectures     = ["x86_64"]
  runtime           = "nodejs20.x"
  handler           = "index.handler"
  timeout           = 10
  memory_size       = 1024

  vpc_config {
    ipv6_allowed_for_dual_stack = false
    subnet_ids = data.aws_subnets.default.ids
    security_group_ids =[aws_security_group.postgres.id]
    #security_group_ids = data.aws_security_groups.default.ids
  }
}

##CREATE LAMBDA FUNCTION URL
resource "aws_lambda_function_url" "server" {
  function_name      = aws_lambda_function.server.function_name
  authorization_type = "AWS_IAM"
  invoke_mode        = "RESPONSE_STREAM"
}

##CREATE LAMBDA LOG GROUP
resource "aws_cloudwatch_log_group" "config" {
  name = "/aws/lambda/${aws_lambda_function.server.function_name}"
  retention_in_days = 14
}

# ## CREATE LAMBDA FUNCTION URL POLICY
# resource "aws_iam_role_policy" "invokeFunctionUrl" {
#   name = "invokeFunctionUrl"
#   role = aws_iam_role.main.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = ["lambda:InvokeFunctionUrl"],
#         Resource = "arn:aws:lambda:${var.aws_region}:${var.account_id}:${aws_lambda_function.server.function_name}"
#       },
#     ]
#   })
# }

## CREATE function.zip
# data "archive_file" "lambda_zip" {
#   type = "zip"
#   source_dir  = ".${path.module}/"
#   output_path = ".${path.module}/function.zip"
#   excludes = [ 
#     "app", 
#     "build/client", 
#     "prisma",
#     "public",
#     "terraform",
#     ".eslintrc.cjs",
#     ".gitignore",
#     ".github",
#     "package-lock.json",
#     "README.md",
#     "tsconfig.json",
#     "vite.config.ts",
#     ]
# }