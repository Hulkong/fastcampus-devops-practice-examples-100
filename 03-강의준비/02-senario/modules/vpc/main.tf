resource "aws_vpc" "example" {
  cidr_block = "10.4.0.0/16"

  tags = {
    terraform = "true"
    Name      = "part03-01-senario"
  }
}

output "vpc_id" {
  value = aws_vpc.example.id
}
