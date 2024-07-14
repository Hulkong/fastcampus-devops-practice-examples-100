variable "subnet_id" {}

resource "aws_instance" "example" {
  ami               = "ami-0ea4e9f7a6f7c30c8"
  instance_type     = "t2.micro"
  subnet_id         = var.subnet_id
  availability_zone = "us-west-2a"

  tags = {
    Name = "example-instance"
  }
}
