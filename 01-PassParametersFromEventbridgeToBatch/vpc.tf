data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}


data "aws_subnet" "demo_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.demo_subnet_name]
  }
}
