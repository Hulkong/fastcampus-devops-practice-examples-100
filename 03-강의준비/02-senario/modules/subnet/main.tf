variable "vpc_id" {}

data "aws_vpc" "example" {
  id = var.vpc_id
}

resource "aws_subnet" "example" {
  vpc_id            = var.vpc_id
  availability_zone = "us-west-2a"
  cidr_block        = cidrsubnet(data.aws_vpc.example.cidr_block, 8, 1)
}

output "subnet_id" {
  value = aws_subnet.example.id
}
