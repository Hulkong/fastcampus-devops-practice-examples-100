variable "subnet_id" {}

resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c574c8"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id

  tags = {
    Name = "example-instance"
  }
}
