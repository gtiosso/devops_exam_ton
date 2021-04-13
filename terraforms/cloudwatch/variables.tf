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
  default     = "lab"
}


## Global Tags

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


## CloudWatch Variables
variable "metric_alarm" {
  type = object({
    name                = string
    comparison_operator = string
    evaluation_periods  = string
    metric_name         = string
    namespace           = string
    period              = string
    statistic           = string
    threshold           = string
    description         = string
  })
  description = "Cloudwatch Metric Alarm values"
}

variable "instance" {
  type = object({
    name                        = string
  })
  description = "EC2 Instance values"
}
