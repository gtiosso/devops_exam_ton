## Important
You may have to execute this manually, but it's ok to run it on a pipeline.

## Usage example

Use the proper state file, depending on the environment:
```sh
# By default, terraform.tfstate should be a lab account state
$ cp -f terraform.tfstate terraform.tfstate.lab.backup

# Now using staging state
$ cp -f terraform.tfstate.prod.backup terraform.tfstate

# If you have to create the S3 backend: (but it's probably already there)
$ terraform init -backend-config="../../configs/prod/prod-init.tfvars"
$ terraform apply -var-file="../../configs/base-tags.tfvars" -var-file="../../configs/prod/prod-vars.tfvars" -var "environment=prod"
```

- ALWAYS keep a lab environment as the default state file
- ALWAYS update the backups file, on any update (not a common task, though)
