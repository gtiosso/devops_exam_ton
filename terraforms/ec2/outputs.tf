## EC2 KEY PAIR OUTPUT ##
output "keypair_private_key_pem" {
  value       = "${module.ec2.keypair_private_key_pem}"
  description = "The private key pair pem"
}

output "keypair_name" {
  value       = "${module.ec2.keypair_name}"
  description = "The key pair name"
}

output "keypair_fingerprint" {
  value       = "${module.ec2.keypair_fingerprint}"
  description = "The MD5 public key fingerprint as specified in section 4 of RFC 4716"
}

## EC2 INSTANCE OUTPUT ##
output "instance_id" {
  value       = "${module.ec2.instance_id}"
  description = "The instance ID"
}

output "instance_arn" {
  value       = "${module.ec2.instance_arn}"
  description = "The ARN of instance"
}

output "instance_availability_zone" {
  value       = "${module.ec2.instance_availability_zone}"
  description = "The availability zone of the instance"
}

output "instance_key_name" {
  value       = "${module.ec2.instance_key_name}"
  description = "The key name of the instance"
}

output "instance_public_dns" {
  value       = "${module.ec2.instance_public_dns}"
  description = "The public DNS name assigned to the instance"
}

output "instance_public_ip" {
  value       = "${module.ec2.instance_public_ip}"
  description = "The public IP address assigned to the instance"
}

output "instance_private_dns" {
  value       = "${module.ec2.instance_private_dns}"
  description = "The private DNS name assigned to the instance"
}

output "instance_private_ip" {
  value       = "${module.ec2.instance_private_ip}"
  description = "The private IP address assigned to the instance"
}

output "instance_security_groups" {
  value       = "${module.ec2.instance_security_groups}"
  description = "The associated security groups"
}

output "instance_subnet_id" {
  value       = "${module.ec2.instance_subnet_id}"
  description = "The VPC subnet ID"
}

output "instance_state" {
  value       = "${module.ec2.instance_state}"
  description = "The state of the instance"
}

output "instance_name_public_ip" {
  value       = "${module.ec2.instance_name_public_ip}"
  description = "The state of the instance"
}

output "launch_configuration_id" {
  value       = "${module.ec2.launch_configuration_id}"
  description = "The Launch Configuration ID"
}
output "launch_configuration_arn" {
  value       = "${module.ec2.launch_configuration_arn}"
  description = "The Launch Configuration Name"
}
output "launch_configuration_name" {
  value       = "${module.ec2.launch_configuration_name}"
  description = "The Launch Configuration Name"
}
