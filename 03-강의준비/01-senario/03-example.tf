# 3. 모듈 사용으로 인한 종속성 이슈
# 이 코드는 VPC, Subnet, EC2 인스턴스를 생성하는 세 개의 모듈을 사용합니다. 각 모듈은 이전 모듈의 출력을 입력으로 사용하므로, 모듈 간에는 강력한 종속성이 있습니다.
# 이러한 종속성 때문에, 한 모듈에서 문제가 발생하면 다른 모듈에도 영향을 미칠 수 있습니다. 예를 들어, VPC 모듈에서 에러가 발생하면, Subnet과 EC2 모듈도 올바르게 실행되지 않을 수 있습니다.
# 또한, 이러한 종속성은 변경사항을 적용하는 것을 더 복잡하게 만들 수 있습니다. 예를 들어, VPC의 설정을 변경하려면, Subnet과 EC2 모듈도 함께 변경해야 할 수 있습니다.

# module "vpc" {
#   source = "./modules/vpc"
# }

# module "subnet" {
#   source = "./modules/subnet"

#   vpc_id = module.vpc.vpc_id
# }

# module "ec2" {
#   source = "./modules/ec2"

#   subnet_id = module.subnet.subnet_id
# }
