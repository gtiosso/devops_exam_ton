## Provider Variables
variable "region" {
  type        = "string"
  description = "AWS default region name"
  default     = "us-east-1"
}

variable "credentials_file" {
  type        = "string"
  description = "Path to AWS credentials file"
  default     = "~/.aws/credentials"
}

variable "profile" {
  type        = "string"
  description = "AWS profile to use on deployment"
}


## Global Tags

variable "context" {
  type        = "string"
  description = "Application context name"
}

variable "environment" {
  type        = "string"
  description = "Deployment environment identifier"
}

variable "team" {
  type        = "string"
  description = "Name of the team responsible for this deployment"
}

variable "app_source" {
  type        = "string"
  description = "Application source repository address"
}

variable "provisioning_tool" {
  type        = "string"
  description = "Provisioning tool name"
}

variable "provisioning_version" {
  type        = "string"
  description = "Provisioning tool version"
}

variable "provisioning_source" {
  type        = "string"
  description = "Provisioning scripts source URL"
}

variable "deployment_tool" {
  type        = "string"
  description = "Deployment tool name"
}

variable "deployment_build_name" {
  type        = "string"
  description = "Build identifier for this deployment"
}


# Module variables
variable "vpc" {
  type = object({
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
  })
  description = "VPC values"
}

variable "sg" {
  type = object({
    name        = string
    description = string
  })
  description = "Security Group values"
}

variable "sg_ingress" {
  type = list(object({
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Security Group Ingress values"
}

variable "sg_egress" {
  type = list(object({
    from_port   = string
    to_port     = string
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Security Group Egress values"
}
