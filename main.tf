terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.23.1"
    }
  }
}

provider "aws" {
  # Configuration options
}

resource "aws_instance" "Ec2_instance" { // resource creation of ec2 instance 
  ami = var.ami  
  instance_type = var.instance_type
  tags = {
    Name = var.name
  }
  
  root_block_device {
    volume_size = var.volume_size # Adjust the root volume size in GiB
  }

}

resource "aws_key_pair" "Key_pair" {
  key_name   = "my-ec2-key"  # Change to your desired key name
  public_key = tls_private_key.example.public_key_openssh
}

resource "tls_private_key" "example" {
  algorithm = "RSA"  # You can choose a different algorithm if needed
  rsa_bits  = 2048   # You can specify a different key size if needed
}
// Default vpc 
resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_default_security_group" "default" { // Security group
  vpc_id = aws_vpc.mainvpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}