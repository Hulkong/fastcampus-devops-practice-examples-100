provider "aws" {
  region = "us-west-2"
}


# 1. S3 버킷 옵션 변경
# 이 코드를 실행한 후, AWS 콘솔에서 S3 버킷의 ACL을 public으로 변경하면, 테라폼은 변경 사항을 인식하지 못하고, 인프라 배포에 실패할 수 있습니다.
resource "aws_s3_bucket" "bucket" {
  bucket = "part03-01-example-bucket"
  acl    = "private"
}

# 2. Route53 레코드 변경
# 이 코드를 실행한 후, AWS 콘솔에서 레코드를 변경하면, 테라폼은 변경 사항을 인식하지 못하고, 인프라 배포에 실패할 수 있습니다.
# resource "aws_route53_record" "www" {
#   zone_id = "ZXXXXXXXXXXXXX"
#   name    = "www.example.com"
#   type    = "A"
#   ttl     = "300"
#   records = ["192.0.2.44"]
# }
