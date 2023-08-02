resource "aws_ecr_repository" "demo" {
  name = "${local.project}-demo-service"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_lifecycle_policy" "demo" {
  repository = aws_ecr_repository.demo.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last image only",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

#
# Automatically Build and push the image upon Terraform Apply.
# ---
# This should not be the preferred way to build and push to ECR,
# but for the sake of simplicity we will use this quick and dirty method.
#

resource "null_resource" "yarn_build" {
  triggers = {
    alwaysrun = timestamp()
  }

  provisioner "local-exec" {
    working_dir = "./demo-service"
    command     = "aws ecr get-login-password --region ${var.aws_region} | podman login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-1.amazonaws.com"
  }

  provisioner "local-exec" {
    working_dir = "./demo-service"
    command     = "podman build -t ${local.project}-demo-service . --platform linux/amd64"
  }

  provisioner "local-exec" {
    working_dir = "./demo-service"
    command     = "podman tag ${local.project}-demo-service:latest ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-1.amazonaws.com/${local.project}-demo-service:latest"
  }

  provisioner "local-exec" {
    working_dir = "./demo-service"
    command     = "podman push  ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-west-1.amazonaws.com/${local.project}-demo-service:latest"
  }

}
