# 1. S3 버킷을 private에서 public으로 변경
# 이 코드를 실행한 후, AWS 콘솔에서 버킷을 public으로 변경하면, 테라폼은 변경 사항을 인식하지 못하고, 인프라 배포에 실패할 수 있습니다.
# resource "aws_s3_bucket" "example" {
#   bucket = "part03-01-example-bucket"
# }

# resource "aws_s3_bucket_ownership_controls" "example" {
#   bucket = aws_s3_bucket.example.id
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_acl" "example" {
#   depends_on = [aws_s3_bucket_ownership_controls.example]

#   bucket = aws_s3_bucket.example.id
#   acl    = "private"
# }
