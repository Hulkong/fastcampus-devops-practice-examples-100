provider "aws" {
  region = "us-west-2"
}

# 1. 리소스 삭제
# 이 코드를 실행한 후, AWS 콘솔에서 사용자의 이름을 변경하면, 테라폼은 변경 사항을 인식하지 못하고, 인프라 배포에 실패할 수 있습니다.
# resource "aws_iam_user" "user" {
#   name = "test-user"
# }
