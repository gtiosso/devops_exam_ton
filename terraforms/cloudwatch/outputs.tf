output "cloudwatch_dashboard_name" {
  value       = "${module.cloudwatch.cloudwatch_dashboard_name}"
  description = "The name of the dashboard."
}

output "cloudwatch_dashboard_arn" {
  value       = "${module.cloudwatch.cloudwatch_dashboard_arn}"
  description = "The Amazon Resource Name (ARN) of the dashboard."
}

output "cloudwatch_event_permission_id" {
  value       = "${module.cloudwatch.cloudwatch_event_permission_id}"
  description = "The statement ID of the CloudWatch Events permission."
}

output "cloudwatch_event_permission_principal" {
  value       = "${module.cloudwatch.cloudwatch_event_permission_principal}"
  description = "The 12-digit AWS account ID that you are permitting to put events to your default event bus."
}

output "cloudwatch_event_permission_statement_id" {
  value       = "${module.cloudwatch.cloudwatch_event_permission_statement_id}"
  description = "The identifier string for the external account that you are granting permissions to."
}

output "cloudwatch_event_permission_action" {
  value       = "${module.cloudwatch.cloudwatch_event_permission_action}"
  description = "The action that you are enabling the other account to perform."
}

output "cloudwatch_event_rule_id" {
  value       = "${module.cloudwatch.cloudwatch_event_rule_id}"
  description = "The name of the rule."
}

output "cloudwatch_event_rule_arn" {
  value       = "${module.cloudwatch.cloudwatch_event_rule_arn}"
  description = "The Amazon Resource Name (ARN) of the rule."
}

output "cloudwatch_event_rule_name" {
  value       = "${module.cloudwatch.cloudwatch_event_rule_name}"
  description = "The rule's name."
}

output "cloudwatch_log_destination_name" {
  value       = "${module.cloudwatch.cloudwatch_log_destination_name}"
  description = "The name for the log destination."
}

output "cloudwatch_log_destination_arn" {
  value       = "${module.cloudwatch.cloudwatch_log_destination_arn}"
  description = "The Amazon Resource Name (ARN) specifying the log destination."
}

output "cloudwatch_log_group_name" {
  value       = "${module.cloudwatch.cloudwatch_log_group_name}"
  description = "The name of the log group."
}

output "cloudwatch_log_group_arn" {
  value       = "${module.cloudwatch.cloudwatch_log_group_arn}"
  description = "The Amazon Resource Name (ARN) specifying the log group."
}

output "cloudwatch_log_group_retention_in_days" {
  value       = "${module.cloudwatch.cloudwatch_log_group_retention_in_days}"
  description = "The number of days to retain log events in the specified log group."
}

output "cloudwatch_log_metric_filter_name" {
  value       = "${module.cloudwatch.cloudwatch_log_metric_filter_name}"
  description = "The name of the metric filter."
}

output "cloudwatch_log_resource_policy_id" {
  value       = "${module.cloudwatch.cloudwatch_log_resource_policy_id}"
  description = "The name of the CloudWatch log resource policy."
}

output "cloudwatch_log_stream_name" {
  value       = "${module.cloudwatch.cloudwatch_log_stream_name}"
  description = "The name of the log stream."
}

output "cloudwatch_log_stream_arn" {
  value       = "${module.cloudwatch.cloudwatch_log_stream_arn}"
  description = "The Amazon Resource Name (ARN) specifying the log stream."
}

output "cloudwatch_log_subscription_filter_name" {
  value       = "${module.cloudwatch.cloudwatch_log_subscription_filter_name}"
  description = "The name for the subscription filter."
}

output "cloudwatch_metric_alarm_id" {
  value       = "${module.cloudwatch.cloudwatch_metric_alarm_id}"
  description = "The ID of the health check."
}

output "cloudwatch_metric_alarm_arn" {
  value       = "${module.cloudwatch.cloudwatch_metric_alarm_arn}"
  description = "The ARN of the cloudwatch metric alarm."
}
