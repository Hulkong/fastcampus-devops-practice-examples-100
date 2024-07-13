variable "vpc_id" {}

resource "aws_subnet" "example" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
}

output "subnet_id" {
  value = aws_subnet.example.id
}
