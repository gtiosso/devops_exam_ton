## Provider config
variable "region" {
  type        = "string"
  description = "AWS default region name"
}

variable "credentials_file" {
  type        = "string"
  description = "Path to AWS credentials file"
}

variable "profile" {
  type        = "string"
  description = "AWS profile to use on deployment"
}


## Global tags
variable "context" {
  type        = "string"
  description = "Application context name"
}

variable "environment" {
  type        = "string"
  description = "Deployment environment identifier (one of [lab, staging, prod])"
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

## Module Vars
variable "key_name" {
  type        = string
  description = ""
}

variable "sg" {
  type = object({
    name = string
  })
  description = "Security Group values"
}

variable "instance" {
  type = object({
    name                        = string
    type                        = string
    associate_public_ip_address = bool
    private_ip                  = string
    source_dest_check           = bool
    root_volume_size            = string
    root_volume_type            = string
  })
  description = "EC2 Instance values"
}
