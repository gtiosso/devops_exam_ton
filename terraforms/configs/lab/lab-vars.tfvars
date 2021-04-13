# Provider Vars
region           = "us-east-1"
credentials_file = "~/.aws/credentials"
profile          = "lab"
context          = "devops-exam-ton-tiosso"
environment      = "lab"

# S3 Backend Vars
bucket_name = "devops-exam-ton-tiosso-terraform-state-lab"

# VPC Vars
vpc = {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

sg = {
  name        = "sg_tiosso"
  description = "Security Group for Application X"
}

sg_ingress = [
  {
    from_port = "22",
    to_port   = "22",
    protocol  = "tcp",
    cidr_blocks = [
      "170.244.28.224/32", #PUT HERE THE DESIRED ORIGIN IP RANGES
    ]
  },
  {
    from_port = "443",
    to_port   = "443",
    protocol  = "tcp",
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
]

sg_egress = [
  {
    from_port = "0",
    to_port   = "0",
    protocol  = "-1",
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
]


# Cloudwatch Vars
metric_alarm = {
  name                = "cpu-monitoring"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  description         = "This metric monitors ec2 cpu utilization"
}

# EC2 Vars
key_name = "aws-instance"
instance = {
  name                        = "devops-exam-ton-tiosso"
  type                        = "t2.micro"
  associate_public_ip_address = true
  private_ip                  = ""
  source_dest_check           = false
  root_volume_size            = "8"
  root_volume_type            = "standard"
}
