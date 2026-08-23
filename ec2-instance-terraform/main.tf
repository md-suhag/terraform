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


resource "aws_instance" "backend_server" {

  // ami           = data.aws_ami.amazon_linux.id
  ami           = "ami-0332d564d76dbd8d6"
  instance_type = "t3.micro"

  tags = {
    Name = "test-backend-server"
  }
}
