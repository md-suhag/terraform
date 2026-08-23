terraform {

  required_version = ">=1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
  }
}


provider "aws" {

  region = "us-east-1"
}

data "aws_ami" "amazon_linux" {

  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "al2023-ami-*-x86_64"
    ]

  }


  filter {

    name   = "architecture"
    values = ["x86_64"]
  }

}



resource "aws_security_group" "backend_sg" {
  name        = "backend-security-group"
  description = "Security group for backend server"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["103.186.20.2/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-security-group"
  }
}



resource "aws_key_pair" "backend_key" {
  key_name   = "backend-key"
  public_key = file("my-server.pub")
}

resource "aws_instance" "backend_server" {

  // ami           = data.aws_ami.amazon_linux.id
  ami           = "ami-0332d564d76dbd8d6"
  instance_type = "t3.micro"

  key_name = aws_key_pair.backend_key.key_name

  vpc_security_group_ids = [
    aws_security_group.backend_sg.id
  ]

  tags = {
    Name = "test-backend-server"
  }
}
