# AWS [`VPC`](https://aws.amazon.com/vpc/) Terraform module example

Terraform module which creates the following resources on AWS:
* VPC
* Subnet (Private and Public)
* Route Table (Private and Public)
* Internet Gateway
* Nat Gateway
* Elastic IP
* DHCP Option Set
* Peering
* Customer Gateway
* VPN Gateway
* VPN Connectio (Site-2-Site)
* Security Group

These types of resources are supported:

* [aws_vpc](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [aws_subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [aws_vpc_dhcp_options](https://www.terraform.io/docs/providers/aws/r/vpc_dhcp_options.html)
* [aws_vpc_peering_connection](https://www.terraform.io/docs/providers/aws/r/vpc_peering.html)
* [aws_vpn_gateway](https://www.terraform.io/docs/providers/aws/r/vpn_gateway.html)
* [aws_vpn_connection](https://www.terraform.io/docs/providers/aws/r/vpn_connection.html)
* [aws_customer_gateway](https://www.terraform.io/docs/providers/aws/r/customer_gateway.html)
* [aws_route_table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [aws_security_group](https://www.terraform.io/docs/providers/aws/r/security_group.html)

## Terraform version
- This module was written in terraform version 0.12. For more details, see this [page](https://www.hashicorp.com/blog/announcing-terraform-0-12).

## Usage

```hcl
module "vpc" {
  source                = "git::ssh://git@github.com/gtiosso/default_modules_terraform.git//vpc"


  ## GLOBAL OPTIONS ##
  context = "infra"
  environment = "lab"
  team = "infra"
  app_source = "https://github.com/teste/teste.git"
  provisioning_tool = "terraform"
  provisioning_version = "0.12.6"
  provisioning_source = "https://github.com/teste/teste.git"
  deployment_tool = "jenkins"
  deployment_build_name = "teste_provisioning"

  ## VPC OPTIONS ##
  vpc_options		= list(
			    {
			      cidr_block = "10.200.0.0/16"
			      enable_dns_support = true
			      enable_dns_hostnames = true
			      extraTags = {
			      }
			    }
			  )
	

  ## DHCP OPTIONS ##
  dhcp_create		= false
  dhcp_options		= list(
			    {
			      domain_name = ""
			      domain_name_servers = list(
			        "10.100.0.2",
			        "10.254.0.11",
			      )
			      ntp_servers = []
			      netbios_name_servers = []
			      netbios_node_type = ""
			      extraTags = {
			      }
			    }
			  )

  ## PEERING OPTIONS ##
  peer_create		= true
  peer_options		= list(
			    {
			      peer_account_id = "${element(data.terraform_remote_state.vpc.outputs.vpc_owner_id, 1)}"
			      peer_vpc_id = "${element(data.terraform_remote_state.vpc.outputs.vpc_id, 1)}"
			      peer_region = "us-east-1"
			      auto_accept = false
			      peer_destination_context_name = "bridge" 
			      peer_destination_cidr_block = "${element(data.terraform_remote_state.vpc.outputs.vpc_cidr,1)}"
			      extraTags = {
			      }
			    },
			  )

  ## VPN CONNECTION SITE-2-SITE OPTIONS ##
  vpn_create		= false
  vpn_options		= list(
			    {
			      vpn_destination_context_name = "juari",
			      vpn_type = "ipsec.1",
			      cgw_type = "ipsec.1",
			      cgw_bgp_asn = 65000,
			      cgw_ip_address = "222.48.187.81",
			      extraTags = {
			      }
			    },
			  )

  ## ROUTE TABLE PUBLIC OPTIONS ##
  rt_public_options	= list(
			    {
			      destination_cidr_block = list(
			        "0.0.0.0/0",
			      )
			      extraTags = {
			      }
			    }
			  )

  ## SECURITY GROUP OPTIONS ##
  sg_create		= true
  sg_options		= list(
			    {
			      name = "sg_teste_allow",
			      desc = "Security Group Allow",
			      sg_ingress = list(
			        {
			          from_port = "0",
			          to_port = "0",
			          protocol = "-1",
			          cidr_blocks = list(
			            "188.90.226.30/32",
			            "10.0.0.0/8",
			          )
			        },
			      )
			      sg_egress = list(
			        {
  			          from_port = "0"
				  to_port = "0"
				  protocol = "-1"
			          cidr_blocks = list(
			            "0.0.0.0/0",
			          )
			        },
			      )
			      extraTags = {
			      }
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
| [vpc_options](#vpc_options) | List with the arguments to create the VPC resource. | list(map) | [] | yes |
| dhcp_create | Boolean to create or not the DHCP Option Set resource. | bool | - | yes |
| [dhcp_options](#dhcp_options) | List with the arguments to create the DHCP Option Set resource. | list(map) | [] | yes |
| peer_create | Boolean to create or not the Peering resource. | bool | - | yes |
| [peer_options](#peer_options) | List with the arguments to create the Peering resource. | list(map) | [] | yes |
| vpn_create | Boolean to create or not the VPN Site-2-Site Connection resource. | bool | - | yes |
| [vpn_options](#vpn_options) | List with the arguments to create the VPN Site-2-Site Connection resource. | list(map) | [] | yes |
| [rt_public_options](#rt_public_options) | List with the arguments to create the Route Table Public resource. | list(map) | [] | yes |
| sg_create | Boolean to create or not the Security Group resource. | bool | - | yes |
| [sg_options](#sg_options) | List with the arguments to create the Security Group resource. | list(map) | [] | yes |

---

### Arguments
#### **vpc_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidr_block | The CIDR block for the VPC. **Must be ```/16```** | string | "" | yes |
| enable_dns_support | A boolean flag to enable/disable DNS support in the VPC. | bool | true | no |
| enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC. | bool | false | no |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### **dhcp_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| domain_name | The suffix domain name to use by default when resolving non Fully Qualified Domain Names. | string | "" | no |
| domain_name_servers | List of name servers to configure in /etc/resolv.conf. If you want to use the default AWS nameservers you should set this to AmazonProvidedDNS. | list | [] | no |
| ntp_servers | List of NTP servers to configure. | list | [] | no |
| netbios_name_servers | List of NETBIOS name servers. | list | [] | no |
| netbios_node_type | The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network. For more information about these node types, see RFC 2132. | list | [] | no |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### **peer_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| peer_account_id | The AWS account ID of the owner of the peer VPC. Defaults to the account ID the AWS provider is currently connected to. | string | "" | no |
| peer_vpc_id | The ID of the VPC with which you are creating the VPC Peering Connection. | string | "" | yes |
| peer_region | The region of the accepter VPC of the [VPC Peering Connection]. | string | "" | no |
| auto_accept | Accept the peering (both VPCs need to be in the same AWS account). | bool | "" | no |
| peer_destination_context_name | The context name of the accepter VPC Peering | string | "" | yes |
| peer_destination_cidr_block | The cidr block of the accepter VPC Peering | string | "" | yes |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### **vpn_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| vpn_destination_context_name | The context name of the other side of VPN Connection | string | "" | yes |
| vpn_type | The type of VPN connection. The only type AWS supports at this time is "ipsec.1". | string | "" | yes |
| cgw_type | The type of VPN connection. The only type AWS supports at this time is "ipsec.1". | string | "" | yes |
| cgw_bgp_asn | The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN). | number | 65000 | yes |
| cgw_ip_address | The IP address of the gateway's Internet-routable external interface. | string | "" | yes |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### **rt_public_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination_cidr_block | The CIDR block of the route. This argument sets route to Internet Gateway and VPN Gateway only. If **```vpn_create```** is set *true*, type all vpn cidr blocks | string | "" | yes |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

---

#### **sg_options**

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The unique name of the security group. | string | "" | yes |
| desc | The security group description. | string | "" | yes |
| [sg_ingress](#sg_ingress) | Can be specified multiple times for each ingress rule. | block | - | yes |
| [sg_egress](#sg_egress) | Can be specified multiple times for each egress rule. | block | - | yes |
| extraTags | A mapping of custom tags to assign to the resource. | map | {} | no |

##### sg_ingress
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| from_port | The start range port (or ICMP type number if protocol is "icmp"). | number | - | yes |
| to_port | The end range port (or ICMP code if protocol is "icmp"). | number | - | yes |
| protocol | The protocol. **If you select a protocol of "-1" (semantically equivalent to "all", which is not a valid value here), you must specify a "from_port" and "to_port" equal to 0**. If not icmp, tcp, udp, or "-1" use the [protocol number](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml). | string | "" | yes |
| cidr_blocks | List of CIDR blocks. | list | [] | yes |

##### sg_egress
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| from_port | The start range port (or ICMP type number if protocol is "icmp"). | number | - | yes |
| to_port | The end range port (or ICMP code if protocol is "icmp"). | number | - | yes |
| protocol | The protocol. **If you select a protocol of "-1" (semantically equivalent to "all", which is not a valid value here), you must specify a "from_port" and "to_port" equal to 0**. If not icmp, tcp, udp, or "-1" use the [protocol number](https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml). | string | "" | yes |
| cidr_blocks | List of CIDR blocks. | list | [] | yes |

---

## Outputs

| Name | Description |
|------|-------------|
| module.vpc.vpc_arn | Amazon Resource Name (ARN) of VPC |
| module.vpc.vpc_id | The ID of the VPC |
| module.vpc.vpc_owner_id | The ID of the AWS account that owns the VPC |
| module.vpc.vpc_cidr | The CIDR block of the VPC |
| module.vpc.vpc_dns_support | The DNS Support of the VPC |
| module.vpc.vpc_dns_hostnames | The DNS Hostnames of the VPC |
| module.vpc.subnet_private_id | The ID of the subnet |
| module.vpc.subnet_public_id | The ID of the subnet |
| module.vpc.subnet_private_name | The Name of Subnet |
| module.vpc.subnet_public_arn | The ARN of the subnet |
| module.vpc.subnet_public_name | The Name of Subnet |
| module.vpc.igw_id | The ID of the Internet Gateway |
| module.vpc.dhcp_options_id | The ID of the DHCP Options Set |
| module.vpc.peering_id | The ID of the VPC Peering Connection |
| module.vpc.peering_route_id | Route Table identifier and destination |
| module.vpc.vpn_id | The amazon-assigned ID of the VPN connection |
| module.vpc.vpn_type | The type of VPN connection |
| module.vpc.vpn_vgw_id | The ID of the virtual private gateway to which the connection is attached |
| module.vpc.vpn_cgw_id | The ID of the customer gateway to which the connection is attached |
| module.vpc.vpn_tunnel1_address | The public IP address of the first VPN tunnel |
| module.vpc.vpn_tunnel1_cgw_inside_address | The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side) |
| module.vpc.vpn_tunnel1_vgw_inside_address | The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side) |
| module.vpc.vpn_tunnel1_preshared_key | The preshared key of the first VPN tunnel |
| module.vpc.vpn_tunnel2_address | The public IP address of the first VPN tunnel |
| module.vpc.vpn_tunnel2_cgw_inside_address | The RFC 6890 link-local address of the first VPN tunnel (Customer Gateway Side) |
| module.vpc.vpn_tunnel2_vgw_inside_address | The RFC 6890 link-local address of the first VPN tunnel (VPN Gateway Side) |
| module.vpc.vpn_tunnel2_preshared_key | The preshared key of the first VPN tunnel |
| module.vpc.rt_private_id | The ID of the routing table |
| module.vpc.rt_public_id | The ID of the routing table |
| module.vpc.sg_id | The ID of the security group |
| module.vpc.sg_arn | The ARN of the security group |
| module.vpc.sg_vpc_id | The VPC ID of the security group |
| module.vpc.sg_name | The NAME of the security group |
| module.vpc.sg_ingress | The Ingress rules of the security group |
| module.vpc.sg_egress | The Egress rules of the security group |
