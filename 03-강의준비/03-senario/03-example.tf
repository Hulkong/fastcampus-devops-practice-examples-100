# resource "aws_s3_bucket" "example" {
#   count = 101 # 기본 쿼타인 100개를 초과하는 101개의 S3 버킷을 요청

#   bucket = "example-bucket-${count.index}-${random_id.bucket_id[count.index].hex}"

#   tags = {
#     Name = "TestBucket-${count.index}"
#   }
# }

# resource "random_id" "bucket_id" {
#   count       = 101
#   byte_length = 4
# }
