terraform {
  cloud {
    organization = "my_organization_1253"
    workspaces {
      name = "learn-tfc-aws"
  }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2_instance" {
  source   = "./ec2module"
}