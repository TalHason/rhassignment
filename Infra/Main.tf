terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}


module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["Web1", "Web2", "Web3", "HAproxy", "Ansible"])

  name = "${each.key}-Server"

  ami                    = "ami-058e6df85cfc7760b"
  instance_type          = "t2.micro"
  monitoring             = false
  vpc_security_group_ids = ["sg-0f5bbdf79191c9089"]
  subnet_id              = "subnet-08dc03e211f3e0d8d"
  associate_public_ip_address = true
  key_name               = "test"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}