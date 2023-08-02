
#
# Compute Environment for AWS Batch
#
resource "aws_batch_compute_environment" "demo" {
  compute_environment_name = "${local.project}-fargate-ce"

  compute_resources {
    max_vcpus = 1

    security_group_ids = [
      aws_security_group.compute_environment.id
    ]

    subnets = [
      data.aws_subnet.demo_subnet.id,
    ]

    type = "FARGATE"
  }

  service_role = aws_iam_role.compute_environment.arn
  type         = "MANAGED"

  depends_on = [aws_iam_role_policy_attachment.service_role]
}

# security group for batch compute environment
resource "aws_security_group" "compute_environment" {
  name   = "${local.project}-security-group"
  vpc_id = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.project}-security-group"
  }
}

# Role and policies for batch compute environment
resource "aws_iam_role" "compute_environment" {
  name               = "${local.project}-compute-env"
  assume_role_policy = data.aws_iam_policy_document.batch_assume_role.json
}

data "aws_iam_policy_document" "batch_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "service_role" {
  role       = aws_iam_role.compute_environment.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

#
# AWS Batch Queue to schedule job into
#
resource "aws_batch_job_queue" "demo" {
  name     = "${local.project}-demo-queue"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.demo.arn
  ]
}
