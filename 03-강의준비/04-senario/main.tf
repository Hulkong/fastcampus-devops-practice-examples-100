provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["part03"]
  }
}

resource "aws_instance" "docker_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # 예시 AMI ID, 실제 환경에 맞게 변경
  instance_type = "t2.micro"
  key_name      = "your-key-pair" # 기존 키 페어 이름

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io docker-compose
              sudo systemctl start docker
              sudo systemctl enable docker

              # Clone the repository containing Dockerfile and scripts
              git clone https://your-repo-url.git /home/ubuntu/large_data_generator
              cd /home/ubuntu/large_data_generator

              # Build the Docker image
              sudo docker-compose build

              # Run the Docker container
              sudo docker-compose up -d
              EOF

  tags = {
    Name = "DockerInstance"
  }
}

resource "aws_security_group" "instance_sg" {
  vpc_id = data.aws_vpc.selected.id
  name   = "instance_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
