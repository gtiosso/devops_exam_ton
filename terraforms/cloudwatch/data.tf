data "aws_instance" "this" {
  filter {
    name   = "tag:Name"
    values = [var.instance.name]
  }
}
