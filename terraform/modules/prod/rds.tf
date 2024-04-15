## CREATE LAMBDA CLOUDWATCH LOGS POLICY
resource "aws_iam_role_policy" "rdsMonitoringRole" {
  name = "${var.app_name}-${var.environment}-rdsMonitoringRole"
  role = aws_iam_role.main.id
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [{
      Effect: "Allow",
      Action: [
          "logs:CreateLogGroup",
          "logs:PutRetentionPolicy"
      ],
      Resource: "arn:aws:logs:*:*:log-group:RDS*"
      #arn:aws:logs:{Region}:{Account}:log-group:{LogGroupName}
    },
    {
      Effect: "Allow",
      Action: [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
      ],
      Resource: "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
      #arn:aws:logs:{Region}:{Account}:log-group:{LogGroupName}:log-stream:{LogStreamName}
    }]
  })
}

resource "aws_db_instance" "postgres" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "postgres"
  engine_version = "16.1"
  instance_class = "db.t3.micro"
  identifier = "${var.app_name}-${var.environment}"
  username = var.db_username
  password = var.db_password

  publicly_accessible = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  performance_insights_retention_period = 7

  vpc_security_group_ids = [aws_security_group.postgres.id]
  #vpc_security_group_ids = data.aws_security_groups.default.ids

  backup_retention_period = 7
  backup_window = "03:00-04:00"
  maintenance_window = "mon:04:00-mon:04:30"

  skip_final_snapshot = true
  #skip_final_snapshot = false
  #final_snapshot_identifier = "${var.app_name}-final-snapshot"

  monitoring_interval = 60 # Interval in seconds (minimum 60 seconds)
  monitoring_role_arn = aws_iam_role.main.arn

  performance_insights_enabled = true

}