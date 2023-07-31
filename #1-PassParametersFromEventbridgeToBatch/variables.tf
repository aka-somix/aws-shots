variable "owner" {
  type        = string
  description = "Project owner, replace with your name"
}

variable "demo_subnet_name" {
  type        = string
  description = "Already existing subnet to place the Demo AWS Batch Compute Environment into"
}

variable "aws_region" {
  type        = string
  description = "The AWS Region to deploy the infrastructure to"
}
