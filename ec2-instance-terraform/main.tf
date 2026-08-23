terraform {

	required_version: ">=1.0"

	required_providers {
	 aws ={
	 source = "hasicrop/aws"
	 version = "~>6.0"
	}
	}
}


provider "aws" {

 region = "us-east-1"
}


resource "aws_instance" "backend_server" {

	ami =  ""
	instance_type = "t3.micro"

	tags = {
	 Name = "test-backend-server"
	}
}
