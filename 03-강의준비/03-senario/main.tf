terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
  }
}

provider "aws" {
  region = "us-west-2" # 원하는 AWS 리전으로 변경
}

resource "aws_eip" "example" {
  count = 6 # 기본 쿼타인 5개를 초과하는 6개의 EIP를 요청

  tags = {
    Name = "TestEIP-${count.index}"
  }
}

resource "aws_s3_bucket" "example" {
  count = 101 # 기본 쿼타인 100개를 초과하는 101개의 S3 버킷을 요청

  bucket = "example-bucket-${count.index}-${random_id.bucket_id[count.index].hex}"

  tags = {
    Name = "TestBucket-${count.index}"
  }
}

resource "random_id" "bucket_id" {
  count       = 101
  byte_length = 4
}

resource "aws_cloudwatch_metric_alarm" "example" {
  count = 5001 # 기본 쿼타인 5000개를 초과하는 5001개의 CloudWatch 알람을 요청

  alarm_name          = "example-alarm-${count.index}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  alarm_actions = []

  dimensions = {
    InstanceId = "i-1234567890abcdef0"
  }

  tags = {
    Name = "TestAlarm-${count.index}"
  }
}

resource "aws_vpc" "example" {
  count = 6 # 기본 쿼타인 5개를 초과하는 6개의 VPC를 요청

  cidr_block = "10.${count.index}.0.0/16"

  tags = {
    Name = "TestVPC-${count.index}"
  }
}
