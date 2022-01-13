// TERRAFORM CONFIGURATION

terraform {
  required_version = "~> 1.1.0"

  backend "s3" {
    bucket = "tgardiner-terraform"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.46.0"
    }
  }
}

// PROVIDER CONFIGURATION

provider "aws" {
  region = var.region
}

// MODULES

module "vpc" {
  source = "./vpc"

  name           = var.name
  region         = var.region
  vpc_network    = var.vpc_network
  vpc_netmask    = var.vpc_netmask
  subnet_netmask = var.vpc_subnet_netmask
}

module "openvpn" {
  source = "./openvpn"

  name           = var.name
  vpc_id         = module.vpc.vpc_id
  ec2_subnet_ids = module.vpc.public_subnets
  ami_id         = var.openvpn_ami_id
  instance_type  = var.openvpn_instance_type
}
