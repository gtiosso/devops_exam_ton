terraform {
  backend "s3" {
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = var.credentials_file
  profile                 = var.profile
}

module "vpc" {
  source = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//vpc"
  #source = "../../../default_modules_terraform/vpc"


  ## GLOBAL OPTIONS ##
  context               = var.context
  environment           = var.environment
  team                  = var.team
  app_source            = var.app_source
  provisioning_tool     = var.provisioning_tool
  provisioning_version  = var.provisioning_version
  provisioning_source   = var.provisioning_source
  deployment_tool       = var.deployment_tool
  deployment_build_name = var.deployment_build_name

  dhcp_create = false
  peer_create = false
  vpn_create  = false

  vpc_options = list(
    {
      cidr_block           = var.vpc.cidr_block
      enable_dns_support   = var.vpc.enable_dns_support
      enable_dns_hostnames = var.vpc.enable_dns_hostnames
      extraTags = {
      }
    }
  )

  rt_public_options = list(
    {
      destination_cidr_block = list(
        "0.0.0.0/0",
      )
      extraTags = {
      }
    }
  )

  sg_create = true
  sg_options = list(
    {
      name       = var.sg.name,
      desc       = var.sg.description,
      sg_ingress = var.sg_ingress,
      sg_egress  = var.sg_egress,
      extraTags = {
      }
    },
  )
}
