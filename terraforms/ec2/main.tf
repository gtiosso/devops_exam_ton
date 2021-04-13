terraform {
  backend "s3" {
    key    = "ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.credentials_file}"
  profile                 = "${var.profile}"
}

module "ec2" {
  source = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//ec2"
  #source = "../../../default_modules_terraform/ec2"

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

  ## EC2 KEY PAIR OPTIONS ##
  key_pair_create = true
  key_pair_options = list(
    {
      key_name = var.key_name,
    },
  )

  ## EC2 INSTANCE OPTIONS ##
  instance_create = true
  instance_options = list(
    {
      name                        = var.instance.name,
      ami                         = data.aws_ami.this.id,
      type                        = var.instance.type,
      associate_public_ip_address = var.instance.associate_public_ip_address,
      subnet_name                 = var.instance.associate_public_ip_address == true ? format("subnet-%s-public-zone-a", var.context) : format("subnet-%s-private-zone-a", var.context),
      private_ip                  = var.instance.private_ip,
      iam_instance_profile        = "",
      source_dest_check           = var.instance.source_dest_check,
      key_name                    = var.key_name,
      user_data                   = "",
      root_volume_size            = var.instance.root_volume_size,
      root_volume_type            = var.instance.root_volume_type,
      create_ebs_block_device     = false
      ebs_block_device = list(
        {
          device_name = ""
          volume_type = ""
          volume_size = ""
        },
      )
      security_group_names = list(var.sg.name),
      extraTags = {
      }
    },
  )

  ## EC2 INSTANCE LAUNCH CONFIGURATION OPTIONS ##
  launch_configuration_create = false
}

resource "local_file" "private_key" {
  sensitive_content = module.ec2.keypair_private_key_pem[0]
  filename          = format("%s/%s", join("/", chunklist(split("/", abspath(path.root)), length(split("/", abspath(path.root))) - 2)[0]), "ansible/devops-exam-ton-tiosso.pem")
  file_permission   = "0600"
}
resource "local_file" "ansible_inventory" {
  content = templatefile("inventory.tmpl", {
      ip          = module.ec2.instance_public_ip[0],
      ssh_keyfile = local_file.private_key.filename
  })
  filename = format("%s/%s", join("/", chunklist(split("/", abspath(path.root)), length(split("/", abspath(path.root))) - 2)[0]), "ansible/inventory")
}
