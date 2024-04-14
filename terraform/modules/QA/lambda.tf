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
