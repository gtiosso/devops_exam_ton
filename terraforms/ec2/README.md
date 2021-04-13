# AWS [`EC2`](https://aws.amazon.com/ec2/) Terraform module example

Terraform module which creates the following resources on AWS:
* Private Key Pair
* EC2 Instance

These types of resources are supported:

* [aws_key_pair](https://www.terraform.io/docs/providers/aws/r/key_pair.html)
* [aws_ec2_instance](https://www.terraform.io/docs/providers/aws/d/instance.html)

## Terraform version
- This module was written in terraform version 0.12. For more details, see this [page](https://www.hashicorp.com/blog/announcing-terraform-0-12).

## Usage

```hcl
module "ec2" {
  source = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//ec2"

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

  ## EC2 KEY PAIR OPTIONS ##
  key_pair_create = true
  key_pair_options = list(
    {
      key_name        = "aws-instance-teste",
    },
  )

  ## EC2 INSTANCE OPTIONS ##
  instance_create = true
  instance_options = list(
    {
      name                        = "instance-public",
      ami                         = "ami-0b898040803850657",
      type                        = "t2.nano",
      subnet_name                 = "subnet-public-infra-zone-a",
      associate_public_ip_address = true,
      private_ip                  = "",
      iam_instance_profile        = "",
      source_dest_check           = true,
      key_name                    = "aws-instance-teste",
      root_volume_size            = "8",
      root_volume_type            = "standard",
      create_ebs_block_device     = false
      ebs_block_device = list(
        {
          device_name = ""
          volume_type = ""
          volume_size = ""
        },
      )
      security_group_names = list(
        "sg_teste_allow",
      )
      extraTags = {
      }
    },
  )

  ## EC2 INSTANCE LAUNCH CONFIGURATION OPTIONS ##
  launch_configuration_create = true
  launch_configuration_options = list(
    {
      name                          = "haproxy-public",
      image_id  = "ami-0b898040803850657",
      instance_type  = "t2.nano",
      key_name  = "aws-haproy"
      associate_public_ip_address  = true,
      spot_price                  = "0.0960",
      user_data                   = null,
      root_volume_size  = "8",
      root_volume_type  = "standard",
      create_ebs_block_device  = false
      ebs_block_device = list(
        {
          device_name = ""
          volume_type = ""
          volume_size = ""
        },
      ),
      security_group = list(
        "sg_teste_allow",
      ),
    }
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
| key_pair_create | Boolean to create or not the Private Key Pair resource. | bool | - | yes |
| [key_pair_options](#key_pair_options) | List with the arguments to create the Private Key Pair resource. | list(map) | [] | yes |
| instance_create | Boolean to create or not the EC2 Instance resource. | bool | - | yes |
| [instance_options](#instance_options) | List with the arguments to create the EC2 Instance resource. | list(map) | [] | yes |
| launch_configuration_create | Boolean to create or not the EC2 AutoScaling Group resource. | bool | - | yes |
| [launch_configuration_options](#launch_configuration_options) | List with the arguments to create the EC2 AutoScaling Group resource. | list(map) | [] | yes |

---

### Arguments
#### **key_pair_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| key_name | The name for the key pair. | string | "" | yes |

---

#### **instance_options**
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of instance. | string | "" | yes |
| ami | The AMI to use for the instance. | string | "" | yes |
| type | The type of instance to start. Updates to this field will trigger a stop/start of the EC2 instance. | string | "" | yes |
| subnet_name | The VPC Subnet name to launch in. | string | "" | yes |
| associate_public_ip_address | Associate a public ip address with an instance in a VPC. | bool | - | yes |
| private_ip | Private IP address to associate with the instance in a VPC. | string | "" | no |
| iam_instance_profile | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile. Ensure your credentials have the correct permission to assign the instance profile according to the EC2 documentation, notably iam:PassRole | string | "" | no |
| source_dest_check | Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs. | bool | - | no |
| key_name | The key name of the Key Pair to use for the instance; which can be managed using [the **```aws_key_pair```** resource](https://www.terraform.io/docs/providers/aws/r/key_pair.html). | string | "" | yes |
| root_volume_size | The size of the volume in gibibytes (GiB). | string | "" | yes |
| root_volume_type | The type of volume. Can be **```"standard"```**, **```"gp2"```**, **```"io1"```**, **```"sc1"```**, or **```"st1"```**. | string | "" | yes |
| create_ebs_block_device | Boolean to create or not the **```ebs_block_device```** block. | bool | - | yes |
| [ebs_block_device](#ebs_block_device) | Additional EBS block devices to attach to the instance. Block device configurations only apply on resource creation. See [Block Devices](https://www.terraform.io/docs/providers/aws/r/instance.html#block-devices) below for details on attributes and drift detection. | block | - | no |
| security_group_names | A list of security group names to associate with. | list | [] | yes |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

##### ebs_block_device
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| device_name | The name of the device to mount. | string | "" | no |
| volume_type | The type of volume. Can be **```"standard"```**, **```"gp2"```**, **```"io1"```**. | string | "" | no |
| volume_size | The size of the volume in gibibytes (GiB). | string | "" | no |

---

## Outputs

| Name | Description |
|------|-------------|
| module.ec2.keypair_name | The key pair name |
| module.ec2.keypair_fingerprint | The MD5 public key fingerprint as specified in section 4 of RFC 4716 |
| module.ec2.instance_id | The instance ID |
| module.ec2.instance_arn | The ARN of instance |
| module.ec2.instance_availability_zone | The availability zone of the instance |
| module.ec2.instance_key_name | The key name of the instance |
| module.ec2.instance_public_dns | The public DNS name assigned to the instance |
| module.ec2.instance_public_ip | The public IP address assigned to the instance |
| module.ec2.instance_private_dns | The private DNS name assigned to the instance |
| module.ec2.instance_private_ip | The private IP address assigned to the instance |
| module.ec2.instance_security_groups | The associated security groups |
| module.ec2.instance_subnet_id | The VPC subnet ID |
| module.ec2.instance_state | The state of the instance |
| module.ec2.instance_name_public_ip | The state of the instance |
