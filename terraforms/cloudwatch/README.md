# AWS [`CLOUDWATCH`](https://aws.amazon.com/cloudwatch/) Terraform module example

Terraform module which creates the following resources on AWS:
* CloudWatch Dashboard
* CloudWatch Event Permission
* CloudWatch Event Rule
* CloudWatch Event Target
* CloudWatch Log Destination
* CloudWatch Log Destination Policy
* CloudWatch Log Group
* CloudWatch Log Metric Filter
* CloudWatch Log Stream
* CloudWatch Log Resource Policy
* CloudWatch Log Subscriprtion Filter
* CloudWatch Metric Alarm

These types of resources are supported:
* [aws_cloudwatch_dashboard](https://www.terraform.io/docs/providers/aws/r/cloudwatch_dashboard.html)
* [aws_cloudwatch_event_permission](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_permission.html)
* [aws_cloudwatch_event_rule](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html)
* [aws_cloudwatch_event_target](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_target.html)
* [aws_cloudwatch_log_destination](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_destination.html)
* [aws_cloudwatch_log_destination_policy](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_destination_policy.html)
* [aws_cloudwatch_log_group](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_group.html)
* [aws_cloudwatch_log_metric_filter](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_metric_filter.html)
* [aws_cloudwatch_log_stream](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_stream.html)
* [aws_cloudwatch_log_resource_policy](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_resource_policy.html)
* [aws_cloudwatch_log_subscription_filter](https://www.terraform.io/docs/providers/aws/r/cloudwatch_log_subscription_filter.html)
* [aws_cloudwatch_metric_alarm](https://www.terraform.io/docs/providers/aws/r/cloudwatch_metric_alarm.html)

## Terraform version
- This module was written in terraform version 0.12. For more details, see this [page](https://www.hashicorp.com/blog/announcing-terraform-0-12).

## Usage

```hcl
module "cloudwatch" {
  source = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//cloudwatch"

  ## GLOBAL OPTIONS ##
  context               = "infra"
  environment           = "lab"
  team                  = "infra"
  app_source            = "https://github.com/teste/teste.git"
  provisioning_tool     = "terraform"
  provisioning_version  = "0.12.6"
  provisioning_source   = "https://github.com/teste/teste_terraform.git"
  deployment_tool       = "jenkins"
  deployment_build_name = "teste_provisioning"

  cloudwatch_dashboard_create = true
  cloudwatch_dashboard_options = list(
    {
      dashboard_name      = "cloudwatch-dashboard-infra-teste",
      dashboard_json_file = "documents/dashboard-body.json",
    },
  )

  cloudwatch_event_permission_create = true
  cloudwatch_event_permission_options = list(
    {
      principal        = "123456789012",
      statement_id     = "DevAccountAccess",
      action           = "events:PutEvents",
      create_condition = true,
      condition = list(
        {
          key   = "aws:PrincipalOrgID",
          type  = "StringEquals",
          value = "${data.aws_organizations_organization.this.id}",
        },
      )
    },
  )

  cloudwatch_event_rule_create = true
  cloudwatch_event_rule_options = list(
    {
      name                    = "capture-aws-sign-in",
      description             = "Capture each AWS Console Sign In",
      event_pattern_json_file = "documents/event_pattern.json",
      schedule_expression     = "",
      role_arn                = "${data.aws_iam_role.cloudwatch_event_rule.arn}",
      is_enabled              = true,
      extraTags = {
      }
    },
  )

  cloudwatch_event_target_create = true
  cloudwatch_event_target_options = list(
    {
      rule_name                  = "capture-aws-sign-in",
      target_id                  = "Yada",
      arn                        = "${data.aws_kinesis_stream.test_stream.arn}",
      input_json_file            = "documents/event_taget_input.json",
      role_arn                   = "${data.aws_iam_role.ssm_lifecycle.arn}",
      create_run_command_targets = false,
      run_command_targets = list(
        {
          key    = "tag:Name",
          values = ["FooBar"],
        },
        {
          key    = "tag:Terminate",
          values = ["midnight"],
        },
      )
      create_ecs_target = false,
      ecs_target = list(
        {
          group               = "",
          launch_type         = "FARGATE",
          platform_version    = "",
          task_count          = 2,
          task_definition_arn = "${data.aws_ecs_task_definition.task_name.arn}",
          subnet_names = list(
          )
          security_group_names = list(
          )
        },
      )
      create_batch_target = false,
      batch_target = list(
        {
          job_definition = "",
          job_name       = "job_teste",
          array_size     = 10,
          job_attempts   = 5,
        },
      )
      create_kinesis_target = false,
      kinesis_target = list(
        {
          partition_key_path = "",
        },
      )
      create_sqs_target = false,
      sqs_target = list(
        {
          message_group_id = "",
        },
      )
      create_input_transformer = false,
      input_transformer = list(
        {
          input_paths    = "",
          input_template = "",
        },
      )
    },
  )

  cloudwatch_log_destination_create = true
  cloudwatch_log_destination_options = list(
    {
      name       = "test_destination",
      role_arn   = "${data.aws_iam_role.iam_for_cloudwatch.arn}",
      target_arn = "${data.aws_kinesis_stream.kinesis_for_cloudwatch.arn}",
    },
  )

  cloudwatch_log_destination_policy_create = true
  cloudwatch_log_destination_policy_options = list(
    {
      destination_name = "test_destination",
      access_policy    = "${data.aws_iam_policy_document.test_destination_policy.json}",
    },
  )

  cloudwatch_log_group_create = true
  cloudwatch_log_group_options = list(
    {
      name              = "teste-group",
      retention_in_days = 14,
      extraTags = {
      }
    },
  )

  cloudwatch_log_metric_filter_create = true
  cloudwatch_log_metric_filter_options = list(
    {
      name           = "MyAppAccessCount",
      pattern        = "",
      log_group_name = "teste-group",
      metric_transformation = list(
        {
          name          = "EventCount",
          namespace     = "YourNamespace",
          value         = "1",
          default_value = "1",
        },
      )
    },
  )

  cloudwatch_log_stream_create = true
  cloudwatch_log_stream_options = list(
    {
      name           = "SampleLogStream1234",
      log_group_name = "teste-group",
    },
  )

  cloudwatch_log_resource_policy_create = true
  cloudwatch_log_resource_policy_options = list(
    {
      policy_document = "${data.aws_iam_policy_document.elasticsearch-log-publishing-policy.json}",
      policy_name     = "elasticsearch-log-publishing-policy",
    },
  )

  cloudwatch_log_subscription_filter_create = true
  cloudwatch_log_subscription_filter_options = list(
    {
      name            = "test_lambdafunction_logfilter",
      role_arn        = "${data.aws_iam_role.iam_for_lambda.arn}",
      log_group_name  = "teste-group",
      filter_pattern  = "logtype test",
      destination_arn = "${data.aws_kinesis_stream.test_logstream.arn}",
      distribution    = "Random",
    },
  )

  cloudwatch_metric_alarm_create = true
  cloudwatch_metric_alarm_options = list(
    {
      alarm_name                = "terraform-test-foobar5",
      comparison_operator       = "GreaterThanOrEqualToThreshold",
      evaluation_periods        = "2",
      metric_name               = "CPUUtilization",
      namespace                 = "AWS/EC2",
      period                    = "120",
      statistic                 = "Average",
      threshold                 = "80",
      alarm_description         = "This metric monitors ec2 cpu utilization",
      insufficient_data_actions = [],
      dimensions                = {
        InstanceId = "i-0abf927ca4606aef0"
      },
    },
  )
}
```

## Global Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| context | Name of team context. | string | "" | yes |
| environment | Name of environment. | string | "" | yes |
| team | Name of team. | string | "" | yes |
| app_source | Link of application git repository. | string | "" | yes |
| provisioning_tool | Name of provisioning tool. | string | "" | yes |
| provisioning_version | Version of provisioning tool. | string | "" | yes |
| provisioning_source | Link of provisioning tool git repository. | string | "" | yes |
| deployment_tool | Name of deployment tool. | string | "" | yes |
| deployment_build_name | Name of deployment build. | string | "" | yes |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudwatch_dashboard_create | Boolean to create or not the Cloudwatch Dashboard resource. | bool | - | yes |
| [cloudwatch_dashboard_options](#cloudwatch_dashboard_options) | List with the arguments to create the Cloudwatch Dashboard resource. | list(map) | [] | yes |
| cloudwatch_event_permission_create | Boolean to create or not the Cloudwatch Event Permission resource. | bool | - | yes |
| [cloudwatch_event_permission_options](#cloudwatch_event_permission_options) | List with the arguments to create the Cloudwatch Event Permission resource. | list(map) | [] | yes |
| cloudwatch_event_rule_create | Boolean to create or not the Cloudwatch Event Rule resource. | bool | - | yes |
| [cloudwatch_event_rule_options](#cloudwatch_event_rule_options) | List with the arguments to create the Cloudwatch Event Rule resource. | list(map) | [] | yes |
| cloudwatch_event_target_create | Boolean to create or not the Cloudwatch Event Target resource. | bool | - | yes |
| [cloudwatch_event_target_options](#cloudwatch_event_target_options) | List with the arguments to create the Cloudwatch Event Target resource. | list(map) | [] | yes |
| cloudwatch_log_destination_create | Boolean to create or not the Cloudwatch Log Destination resource. | bool | - | yes |
| [cloudwatch_log_destination_options](#cloudwatch_log_destination_options) | List with the arguments to create the Cloudwatch Log Destination resource. | list(map) | [] | yes |
| cloudwatch_log_destination_policy_create | Boolean to create or not the Cloudwatch Log Destination Policy resource. | bool | - | yes |
| [cloudwatch_log_destination_policy_options](#cloudwatch_log_destination_policy_options) | List with the arguments to create the Cloudwatch Log Destination Policy resource. | list(map) | [] | yes |
| cloudwatch_log_group_create | Boolean to create or not the Cloudwatch Log Group resource. | bool | - | yes |
| [cloudwatch_log_group_options](#cloudwatch_log_group_options) | List with the arguments to create the Cloudwatch Log Group resource. | list(map) | [] | yes |
| cloudwatch_log_metric_filter_create | Boolean to create or not the Cloudwatch Log Metric resource. | bool | - | yes |
| [cloudwatch_log_metric_filter_options](#cloudwatch_log_metric_filter_options) | List with the arguments to create the Cloudwatch Log Metric Filter resource. | list(map) | [] | yes |
| cloudwatch_log_stream_create | Boolean to create or not the Cloudwatch Log Stream resource. | bool | - | yes |
| [cloudwatch_log_stream_options](#cloudwatch_log_stream_options) | List with the arguments to create the Cloudwatch Log Stream resource. | list(map) | [] | yes |
| cloudwatch_log_resource_policy_create | Boolean to create or not the Cloudwatch Log Resource Policy resource. | bool | - | yes |
| [cloudwatch_log_resource_policy_options](#cloudwatch_log_resource_policy_options) | List with the arguments to create the Cloudwatch Log Resource Policy resource. | list(map) | [] | yes |
| cloudwatch_log_subscription_filter_create | Boolean to create or not the Cloudwatch Log Subscription Filter resource. | bool | - | yes |
| [cloudwatch_log_subscription_filter_options](#cloudwatch_log_subscription_filter_options) | List with the arguments to create the Cloudwatch Log Subscription Filter resource. | list(map) | [] | yes |
| cloudwatch_metric_alarm_create | Boolean to create or not the Cloudwatch Metric Alarm resource. | bool | - | yes |
| [cloudwatch_metric_alarm_options](#cloudwatch_metric_alarm_options) | List with the arguments to create the Cloudwatch Metric Alarm resource. | list(map) | [] | yes |

---

### Arguments
#### cloudwatch_dashboard_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dashboard_name | The name of the dashboard. | string | "" | yes |
| dashboard_json_file | The file path with detailed information about the dashboard, including what widgets are included and their location on the dashboard. You can read more about the body structure in the [documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/CloudWatch-Dashboard-Body-Structure.html).  | string | "" | yes |

---

#### cloudwatch_event_permission_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| principal | The 12-digit AWS account ID that you are permitting to put events to your default event bus. Specify **```*```** to permit any account to put events to your default event bus, optionally limited by **```condition```**.  | string | "" | yes |
| statement_id | An identifier string for the external account that you are granting permissions to. | string | "" | yes |
| action | The action that you are enabling the other account to perform. | string | "" | no |
| create_condition |  | bool | - | no |
| [condition](#condition) | Configuration block to limit the event bus permissions you are granting to only accounts that fulfill the condition. Specified below. | string | "" | yes |

##### condition

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| key | Key for the condition. Valid values: **```aws:PrincipalOrgID```**. | string | "" | yes |
| type | Type of condition. Value values: **```StringEquals```**. | string | "" | yes |
| value | Value for the key. | string | "" | yes |

---

#### cloudwatch_event_rule_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The rule's name. | string | "" | yes |
| description | The description of the rule. | string | "" | yes |
| event_pattern_json_file | **Required, if ```schedule_expression``` isn't specified**. The file path with Event pattern described. See full documentation of [CloudWatch Events and Event Patterns](https://docs.aws.amazon.com/pt_br/AmazonCloudWatch/latest/events/CloudWatchEventsandEventPatterns.html) for details. | file | - | yes |
| schedule_expression | **Required, if ```event_pattern``` isn't specified**. The scheduling expression. For example, **```cron(0 20 * * ? *)```** or **```rate(5 minutes)```**.  | string | "" | yes |
| role_arn | The Amazon Resource Name (ARN) associated with the role that is used for target invocation. | string | "" | yes |
| is_enabled | Whether the rule should be enabled. | bool | - | no |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### cloudwatch_event_target_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| rule_name | The name of the rule you want to add targets to. | string | "" | yes |
| target_id | The unique target assignment ID. If missing, will generate a random, unique id. | string | - | no |
| arn | The Amazon Resource Name (ARN) associated of the target. | string | "" | yes |
| input_json_file | The file path with valid JSON text passed to the target. | string | "" | no |
| role_arn | The Amazon Resource Name (ARN) of the IAM role to be used for this target when the rule is triggered. **Required if ```ecs_target``` is used**.  | string | "" | yes |
| create_run_command_targets | The boolean to creates or not run_command_targets block. | bool | - | yes |
| [run_command_targets](#run_command_targets) | Parameters used when you are using the rule to invoke Amazon EC2 Run Command. Documented below. A maximum of 5 are allowed. | block | - | no |
| create_ecs_target | The boolean to creates or not ecs_target block. | string | "" | yes |
| [ecs_target](#ecs_target) | Parameters used when you are using the rule to invoke Amazon ECS Task. Documented below. A maximum of 1 are allowed. | block | - | no |
| create_batch_target | The boolean to creates or not batch_target block | string | "" | yes |
| [batch_target](#batch_target) | Parameters used when you are using the rule to invoke an Amazon Batch Job. Documented below. A maximum of 1 are allowed. | block | - | no |
| create_kinesis_target | The boolean to creates or not kinesis_target block | string | "" | yes |
| [kinesis_target](#kinesis_target) | Parameters used when you are using the rule to invoke an Amazon Kinesis Stream. Documented below. A maximum of 1 are allowed. | block | - | no |
| create_sqs_target | The boolean to creates or not sqs_target block | string | "" | yes |
| [sqs_target](#sqs_target) | Parameters used when you are using the rule to invoke an Amazon SQS Queue. Documented below. A maximum of 1 are allowed. | block | - | no |
| create_input_transformer | The boolean to creates or not input_transformer block. | string | "" | yes |
| [input_transformer](#input_transformer) | Parameters used when you are providing a custom input to a target based on certain event data.  | block | - | no |

##### run_command_targets

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| key | Can be either **```tag:tag-key```** or **```InstanceIds```**.  | string | "" | yes |
| values | **If Key is ```tag:tag-key```, Values is a list of tag values**. **If Key is ```InstanceIds```, Values is a list of Amazon EC2 instance IDs**.  | list | [] | yes |
---

##### ecs_target

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| group | Specifies an ECS task group for the task. The maximum length is 255 characters. | string | "" | no |
| launch_type | Specifies the launch type on which your task is running. The launch type that you specify here must match one of the launch type (compatibilities) of the target task. Valid values are **```EC2```** or **```FARGATE```**. | string | "" | yes |
| platform_version | Specifies the platform version for the task. Specify only the numeric portion of the platform version, such as 1.1.0. **This is used only if LaunchType is ```FARGATE```**. For more information about valid platform versions, see [AWS Fargate Platform Versions](https://docs.aws.amazon.com/pt_br/AmazonECS/latest/developerguide/platform_versions.html). | string | "" | no |
| task_count | The number of tasks to create based on the TaskDefinition. | number | - | yes |
| task_definition_arn | The ARN of the task definition to use if the event target is an Amazon ECS cluster. | string | "" | yes |
| subnet_names | The list of subnet's name associated with the task or service. | list | [] | yes |
| security_group_names | The list of security groups name associated with the task or service. | list | [] | yes |
---

##### batch_target

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| job_definition | The ARN or name of the job definition to use if the event target is an AWS Batch job. **This job definition must already exist**.  | string | "" | yes |
| job_name | The name to use for this execution of the job, if the target is an AWS Batch job. | string | "" | yes |
| array_size | The size of the array, if this is an array batch job. Valid values are integers between **```2```** and **```10,000```**.  | number | - | no |
| job_attempts | The number of times to attempt to retry, if the job fails. Valid values are **```1```** to **```10```**.  | number | - | no |
---

##### kinesis_target

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| partition_key_path | The JSON path to be extracted from the event and used as the partition key. | string | "" | yes |
---

##### sqs_target

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| message_group_id | The FIFO message group ID to use as the target. | string | "" | yes |
---

##### input_transformer

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| input_paths | Key value pairs specified in the form of JSONPath (for example, time = $.time) | string | "" | no |
| input_template | Structure containing the template body. | string | "" | yes |

---

#### cloudwatch_log_destination_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | A name for the log destination. | string | "" | yes |
| role_arn | The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to put data into the target. | string | "" | yes |
| target_arn | The ARN of the target Amazon Kinesis stream or Amazon Lambda resource for the destination. | string | "" | yes |

---

#### cloudwatch_log_destination_policy_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination_name | A name for the log destination policy. | string | "" | yes |
| access_policy | The policy document. This is a JSON formatted string. | string | "" | yes |

---

#### cloudwatch_log_group_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the log group. | string | "" | yes |
| retention_in_days | Specifies the number of days you want to retain log events in the specified log group. | number | 14 | yes |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### cloudwatch_log_metric_filter_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | A name for the metric filter. | string | "" | yes |
| pattern | A valid [CloudWatch Logs filter pattern](https://docs.aws.amazon.com/pt_br/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html) for extracting metric data out of ingested log events. | string | "" | yes |
| log_group_name | The name of the log group to associate the metric filter with. | string | "" | yes |
| [metric_transformation](#metric_transformation) | A block defining collection of information needed to define how metric data gets emitted. See below. | block | - | yes |

##### metric_transformation

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the CloudWatch metric to which the monitored log information should be published (e.g. **```ErrorCount```**) | string | "" | yes |
| namespace | The destination namespace of the CloudWatch metric. | string | "" | yes |
| value | What to publish to the metric. For example, if you're counting the occurrences of a particular term like "Error", the value will be "1" for each occurrence. If you're counting the bytes transferred the published value will be the value in the log event. | string | "" | yes |
| default_value | The value to emit when a filter pattern does not match a log event. | string | "" | yes |

---

#### cloudwatch_log_stream_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the log stream. **Must not be longer than 512 characters and must not contain ```:```** | string | "" | yes |
| log_group_name | The name of the log group under which the log stream is to be created. | string | "" | yes |

---

#### cloudwatch_log_resource_policy_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| policy_document | Details of the resource policy, including the identity of the principal that is enabled to put logs to this account. This is formatted as a JSON string. Maximum length of 5120 characters.  | string | "" | yes |
| policy_name | Name of the resource policy. | string | "" | yes |

---

#### cloudwatch_log_subscription_filter_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | A name for the subscription filter. | string | "" | yes |
| role_arn | he ARN of an IAM role that grants Amazon CloudWatch Logs permissions to deliver ingested log events to the destination. If you use Lambda as a destination, you should skip this argument and use **```aws_lambda_permission```** resource for granting access from CloudWatch logs to the destination Lambda function.  | string | "" | yes |
| log_group_name | The name of the log group to associate the subscription filter with. | string | "" | yes |
| filter_pattern | A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. | string | "" | yes |
| destination_arn | The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN. | string | "" | yes |
| distribution | The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are "Random" and "ByLogStream". | string | "" | yes |

---

#### cloudwatch_metric_alarm_options

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alarm_name                | The descriptive name for the alarm. This name must be unique within the user's AWS account. | string | "" | yes |
| comparison_operator       | The arithmetic operation to use when comparing the specified Statistic and Threshold. The specified Statistic value is used as the first operand. Either of the following is supported: **```GreaterThanOrEqualToThreshold```**, **```GreaterThanThreshold```**, **```LessThanThreshold```**, **```LessThanOrEqualToThreshold```**.  | string | "" | yes |
| evaluation_periods        | The number of periods over which data is compared to the specified threshold. | string | "" | yes |
| metric_name               | The name for the alarm's associated metric. See docs for [supported metrics](https://docs.aws.amazon.com/pt_br/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). | string | "" | no |
| namespace                 | The namespace for the alarm's associated metric. See docs for the [list of namespaces](https://docs.aws.amazon.com/pt_br/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). See docs for [supported metrics](https://docs.aws.amazon.com/pt_br/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html).  | string | "" | no |
| period                    | The period in seconds over which the specified **```statistic```** is applied. | string | "" | no |
| statistic                 | The statistic to apply to the alarm's associated metric. Either of the following is supported: **```SampleCount```**, **```Average```**, **```Sum```**, **```Minimum```**, **```Maximum```**. | string | "" | no |
| threshold                 | The value against which the specified statistic is compared. | string | "" | yes |
| alarm_description         | The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN). | string | "" | no |
| insufficient_data_actions | The list of actions to execute when this alarm transitions into an INSUFFICIENT_DATA state from any other state. Each action is specified as an Amazon Resource Name (ARN). | list | [] | no |
| dimensions                | The dimensions for the alarm's associated metric. For the list of available dimensions see the AWS documentation [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html). | list | [] | no |

---

## Outputs

| Name | Description |
|------|-------------|
| module.cloudwatch.cloudwatch_dashboard_name | The name of the dashboard. |
| module.cloudwatch.cloudwatch_dashboard_arn | The Amazon Resource Name (ARN) of the dashboard. |
| module.cloudwatch.cloudwatch_event_permission_id | The statement ID of the CloudWatch Events permission. |
| module.cloudwatch.cloudwatch_event_permission_principal | The 12-digit AWS account ID that you are permitting to put events to your default event bus. |
| module.cloudwatch.cloudwatch_event_permission_statement_id | The identifier string for the external account that you are granting permissions to. |
| module.cloudwatch.cloudwatch_event_permission_action | The action that you are enabling the other account to perform. |
| module.cloudwatch.cloudwatch_event_rule_id | The name of the rule. |
| module.cloudwatch.cloudwatch_event_rule_arn | The Amazon Resource Name (ARN) of the rule. |
| module.cloudwatch.cloudwatch_event_rule_name | The rule's name. |
| module.cloudwatch.cloudwatch_log_destination_name | The name for the log destination. |
| module.cloudwatch.cloudwatch_log_destination_arn | The Amazon Resource Name (ARN) specifying the log destination. |
| module.cloudwatch.cloudwatch_log_group_name | The name of the log group. |
| module.cloudwatch.cloudwatch_log_group_arn | The Amazon Resource Name (ARN) specifying the log group. |
| module.cloudwatch.cloudwatch_log_group_retention_in_days | The number of days to retain log events in the specified log group. |
| module.cloudwatch.cloudwatch_log_metric_filter_name | The name of the metric filter. |
| module.cloudwatch.cloudwatch_log_resource_policy_id | The name of the CloudWatch log resource policy. |
| module.cloudwatch.cloudwatch_log_stream_name | The name of the log stream. |
| module.cloudwatch.cloudwatch_log_stream_arn | The Amazon Resource Name (ARN) specifying the log stream. |
| module.cloudwatch.cloudwatch_log_subscription_filter_name | The name for the subscription filter. |
| module.cloudwatch.cloudwatch_metric_alarm_id | The ID of the health check. |
| module.cloudwatch.cloudwatch_metric_alarm_arn | The ARN of the cloudwatch metric alarm. |
| module.cloudwatch.cloudwatch_metric_alarm_alarm_name | The descriptive name for the alarm. |
