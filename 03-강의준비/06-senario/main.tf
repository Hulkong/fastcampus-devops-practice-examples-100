provider "aws" {
  region = "us-west-2" # 원하는 AWS 리전으로 변경
}

# Lambda function source code
resource "local_file" "start_rds_py" {
  filename = "${path.module}/start_rds.py"
  content  = file("${path.module}/start_rds.py")
}

resource "local_file" "stop_rds_py" {
  filename = "${path.module}/stop_rds.py"
  content  = file("${path.module}/stop_rds.py")
}

resource "null_resource" "create_zip" {
  provisioner "local-exec" {
    command = "zip ${path.module}/start_rds.zip ${path.module}/start_rds.py && zip ${path.module}/stop_rds.zip ${path.module}/stop_rds.py"
  }

  triggers = {
    start_rds = sha256(file("${path.module}/start_rds.py"))
    stop_rds  = sha256(file("${path.module}/stop_rds.py"))
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["part03"]
  }
}

data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_vpc.selected.id
  name   = "rds_sg"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  db_subnet_group_name = aws_db_subnet_group.default.name

  tags = {
    Name = "MyRDSInstance"
  }
}

resource "aws_db_subnet_group" "default" {
  name = "my_db_subnet_group"
  subnet_ids = data.aws_subnets.selected.ids

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_rds_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_rds_policy"
  description = "IAM policy for Lambda to manage RDS"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:StopDBInstance",
          "rds:StartDBInstance"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "start_rds" {
  function_name = "start_rds_instance"
  role          = aws_iam_role.lambda_role.arn
  handler       = "start_rds.handler"
  runtime       = "python3.8"
  filename      = "${path.module}/start_rds.zip"

  source_code_hash = filebase64sha256("${path.module}/start_rds.py")

  environment {
    variables = {
      RDS_INSTANCE_ID = aws_db_instance.default.identifier
    }
  }

  depends_on = [null_resource.create_zip]
}

resource "aws_lambda_function" "stop_rds" {
  function_name = "stop_rds_instance"
  role          = aws_iam_role.lambda_role.arn
  handler       = "stop_rds.handler"
  runtime       = "python3.8"
  filename      = "${path.module}/stop_rds.zip"

  source_code_hash = filebase64sha256("${path.module}/stop_rds.py")

  environment {
    variables = {
      RDS_INSTANCE_ID = aws_db_instance.default.identifier
    }
  }

  depends_on = [null_resource.create_zip]
}

resource "aws_cloudwatch_event_rule" "start_rds_rule" {
  name                = "start_rds_rule"
  description         = "Trigger to start RDS instance"
  schedule_expression = "cron(0 8 * * ? *)" # 매일 오전 8시에 실행
}

resource "aws_cloudwatch_event_rule" "stop_rds_rule" {
  name                = "stop_rds_rule"
  description         = "Trigger to stop RDS instance"
  schedule_expression = "cron(0 20 * * ? *)" # 매일 오후 8시에 실행
}

resource "aws_cloudwatch_event_target" "start_rds_target" {
  rule      = aws_cloudwatch_event_rule.start_rds_rule.name
  target_id = "startRdsFunction"
  arn       = aws_lambda_function.start_rds.arn
}

resource "aws_cloudwatch_event_target" "stop_rds_target" {
  rule      = aws_cloudwatch_event_rule.stop_rds_rule.name
  target_id = "stopRdsFunction"
  arn       = aws_lambda_function.stop_rds.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_start" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_rds.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_rds_rule.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_stop" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_rds.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_rds_rule.arn
}
