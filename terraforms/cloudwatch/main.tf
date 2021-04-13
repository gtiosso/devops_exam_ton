terraform {
  backend "s3" {
    key    = "cloudwatch/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = var.credentials_file
  profile                 = var.profile
}

module "cloudwatch" {
  source = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//cloudwatch"
  #source = "../../../default_modules_terraform/cloudwatch"

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

  cloudwatch_dashboard_create               = false
  cloudwatch_event_permission_create        = false
  cloudwatch_event_rule_create              = false
  cloudwatch_event_target_create            = false
  cloudwatch_log_destination_create         = false
  cloudwatch_log_destination_policy_create  = false
  cloudwatch_log_metric_filter_create       = false
  cloudwatch_log_stream_create              = false
  cloudwatch_log_resource_policy_create     = false
  cloudwatch_log_subscription_filter_create = false
  cloudwatch_log_group_create               = false

  cloudwatch_metric_alarm_create = true
  cloudwatch_metric_alarm_options = list(
    {
      alarm_name                = var.metric_alarm.name,
      comparison_operator       = var.metric_alarm.comparison_operator,
      evaluation_periods        = var.metric_alarm.evaluation_periods,
      metric_name               = var.metric_alarm.metric_name,
      namespace                 = var.metric_alarm.namespace,
      period                    = var.metric_alarm.period,
      statistic                 = var.metric_alarm.statistic,
      threshold                 = var.metric_alarm.threshold,
      alarm_description         = var.metric_alarm.description,
      insufficient_data_actions = [],
      dimensions                = {
        InstanceId = data.aws_instance.this.id
      },
    }
  )

}
