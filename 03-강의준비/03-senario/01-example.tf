resource "aws_eip" "example" {
  count = 6

  tags = {
    Name = "TestEIP-${count.index}"
  }
}
