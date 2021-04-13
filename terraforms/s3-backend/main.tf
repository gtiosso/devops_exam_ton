provider "aws" {
  region                  = var.region
  shared_credentials_file = var.credentials_file
  profile                 = var.profile
}

module "s3-backend" {
  source = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//s3-backend"
  #source = "../../../default_modules_terraform/s3-backend"

  ## GLOBAL OPTIONS (Just tags in this case) ##
  context               = var.context
  environment           = var.environment
  team                  = var.team
  app_source            = var.app_source
  provisioning_tool     = var.provisioning_tool
  provisioning_version  = var.provisioning_version
  provisioning_source   = var.provisioning_source
  deployment_tool       = var.deployment_tool
  deployment_build_name = var.deployment_build_name

  ## S3 BACKEND OPTIONS ##
  s3_create = true
  s3_options = list(
    {
      name          = var.bucket_name,
      acl           = "private",
      force_destroy = true,
      versioning    = false,
      sse_algorithm = "AES256",
      extraTags = {
      }
    },
  )
}
