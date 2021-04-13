## VPC OUTPUT ##
output "vpc_arn" {
  value       = "${module.vpc.vpc_arn}"
  description = "Amazon Resource Name (ARN) of VPC"
}

output "vpc_id" {
  value       = "${module.vpc.vpc_id}"
  description = "The ID of the VPC"
}

output "vpc_owner_id" {
  value       = "${module.vpc.vpc_owner_id}"
  description = "The ID of the AWS account that owns the VPC"
}

output "vpc_cidr" {
  value       = "${module.vpc.vpc_cidr}"
  description = "The CIDR block of the VPC"
}

output "vpc_dns_support" {
  value       = "${module.vpc.vpc_dns_support}"
  description = "The DNS Support of the VPC"
}

output "vpc_dns_hostnames" {
  value       = "${module.vpc.vpc_dns_hostnames}"
  description = "The DNS Hostnames of the VPC"
}

## SUBNET PRIVATE OUTPUT ##
output "subnet_private_id" {
  value       = "${module.vpc.subnet_private_id}"
  description = "The ID of the subnet"
}

output "subnet_private_name" {
  value       = "${module.vpc.subnet_private_name}"
  description = "The Name of Subnet"
}

## SUBNET PUBLIC OUTPUT ##
output "subnet_public_id" {
  value       = "${module.vpc.subnet_public_id}"
  description = "The ID of the subnet"
}

output "subnet_public_arn" {
  value       = "${module.vpc.subnet_public_arn}"
  description = "The ARN of the subnet"
}

output "subnet_public_name" {
  value       = "${module.vpc.subnet_public_name}"
  description = "The Name of Subnet"
}

## INTERNET GATEWAY OUTPUT ##
output "igw_id" {
  value       = "${module.vpc.igw_id}"
  description = "The ID of the Internet Gateway"
}

## DHCP OPTIONS OUTPUT ##
output "dhcp_options_id" {
  value       = "${module.vpc.dhcp_options_id}"
  description = "The ID of the DHCP Options Set"
}

## PEERING OUTPUT ##
output "peering_id" {
  value       = "${module.vpc.peering_id}"
  description = "The ID of the VPC Peering Connection"
}

output "peering_route_id" {
  value       = "${module.vpc.peering_route_id}"
  description = "Route Table identifier and destination"
}

## VPN CONNECTION SITE-2-SITE OUTPUT ##
output "vpn_id" {
  value       = "${module.vpc.vpn_id}"
  description = "The amazon-assigned ID of the VPN connection"
}

output "vpn_type" {
  value       = "${module.vpc.vpn_type}"
  description = "The type of VPN connection"
}

output "vpn_vgw_id" {
  value       = "${module.vpc.vpn_vgw_id}"
  description = "The ID of the virtual private gateway to which the connection is attached"
}

output "vpn_cgw_id" {
  value       = "${module.vpc.vpn_cgw_id}"
  description = "The ID of the customer gateway to which the connection is attached"
}

output "vpn_tunnel1_address" {
  value       = "${module.vpc.vpn_tunnel1_address}"
  description = "The public IP address of the first VPN tunnel"
}

output "vpn_tunnel1_cgw_inside_address" {
  value       = "${module.vpc.vpn_tunnel1_cgw_inside_address}"
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)"
}

output "vpn_tunnel1_vgw_inside_address" {
  value       = "${module.vpc.vpn_tunnel1_vgw_inside_address}"
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)"
}

output "vpn_tunnel1_preshared_key" {
  value       = "${module.vpc.vpn_tunnel1_preshared_key}"
  description = "The preshared key of the first VPN tunnel"
}

output "vpn_tunnel2_address" {
  value       = "${module.vpc.vpn_tunnel2_address}"
  description = "The public IP address of the first VPN tunnel"
}

output "vpn_tunnel2_cgw_inside_address" {
  value       = "${module.vpc.vpn_tunnel2_cgw_inside_address}"
  description = "The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side)"
}

output "vpn_tunnel2_vgw_inside_address" {
  value       = "${module.vpc.vpn_tunnel2_vgw_inside_address}"
  description = "The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side)"
}

output "vpn_tunnel2_preshared_key" {
  value       = "${module.vpc.vpn_tunnel2_preshared_key}"
  description = "The preshared key of the first VPN tunnel"
}

## ROUTE TABLE PRIVATE OUTPUT ##
output "rt_private_id" {
  value       = "${module.vpc.rt_private_id}"
  description = "The ID of the routing table"
}

## ROUTE TABLE PUBLIC OUTPUT ##
output "rt_public_id" {
  value       = "${module.vpc.rt_public_id}"
  description = "The ID of the routing table"
}

## SECURITY GROUP OUTPUT ##
output "sg_id" {
  value       = "${module.vpc.sg_id}"
  description = "The ID of the security group"
}

output "sg_arn" {
  value       = "${module.vpc.sg_arn}"
  description = "The ARN of the security group"
}

output "sg_vpc_id" {
  value       = "${module.vpc.sg_vpc_id}"
  description = "The VPC ID of the security group"
}

output "sg_name" {
  value       = "${module.vpc.sg_name}"
  description = "The NAME of the security group"
}

output "sg_ingress" {
  value       = "${module.vpc.sg_ingress}"
  description = "The Ingress rules of the security group"
}

output "sg_egress" {
  value       = "${module.vpc.sg_egress}"
  description = "The Egress rules of the security group"
}

