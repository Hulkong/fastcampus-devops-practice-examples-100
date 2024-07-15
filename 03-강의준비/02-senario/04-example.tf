# 4. 배열 사용 시, 중간에 요소를 추가하거나 삭제하면 리소스가 삭제되고 다시 생성
# 이 코드는 repository_names 변수에 정의된 이름을 사용하여 ECR 리포지토리를 생성합니다. 배열의 각 요소는 aws_ecr_repository.example 리소스의 count.index에 의해 참조되므로, 배열의 순서가 변경되면 상태 파일에 저장된 리소스와 실제 리소스 간의 매핑이 깨집니다.
# 예를 들어, repository_names 배열에 새 리포지토리 이름을 삽입하면, 그 이후의 모든 리포지토리가 삭제되고 새로 생성됩니다. 이는 테라폼이 배열의 순서를 기반으로 리소스를 추적하기 때문입니다.
# 이 문제를 해결하려면, 배열 대신 맵을 사용하거나, 각 리소스에 고유한 식별자를 사용하는 것이 좋습니다.

variable "example01-repository_names" {
  default = ["example01-repo1", "example01-repo2", "example01-repo3"]
}

variable "example02-repository_names" {
  default = ["example02-repo1", "example02-repo2", "example02-repo3"]
}

resource "aws_ecr_repository" "example1" {
  count = length(var.example01-repository_names)
  name  = element(var.example01-repository_names, count.index)
}

resource "aws_ecr_repository" "example2" {
  for_each = toset(var.example02-repository_names)
  name     = each.key
}
