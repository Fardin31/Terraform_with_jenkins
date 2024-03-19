terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {

  region = "us-east-1"
  
}

resource "aws_instance" "this_ec2" {
  ami           = "ami-0d7a109bf30624c99"
  instance_type = "t2.micro"
  key_name      = "fardin12"

}