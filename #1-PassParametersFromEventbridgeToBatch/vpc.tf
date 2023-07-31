data "aws_subnet" "demo_subnet" {
  filter {
    name   = "tag:Name"
    values = [var.demo_subnet_name]
  }
}
