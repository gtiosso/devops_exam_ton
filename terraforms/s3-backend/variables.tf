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
  description = "provisioning scripts source URL"
}

variable "deployment_tool" {
  type        = "string"
  description = "deployment tool name"
}

variable "deployment_build_name" {
  type        = "string"
  description = "deployment build identifier string"
}

## Backend Creation Options
variable "bucket_name" {
  type        = string
  description = "S3 backend bucket name"
}
