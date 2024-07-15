# resource "aws_vpc" "example" {
#   count = 5

#   cidr_block = "10.${count.index}.0.0/16"

#   tags = {
#     Name = "TestVPC-${count.index}"
#   }
# }
