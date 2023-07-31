
resource "aws_batch_job_definition" "demo" {
  name = "${local.project}-demo-jd"
  type = "container"

  platform_capabilities = ["FARGATE"]

  container_properties = <<CONTAINER_PROPERTIES
  {
    "image": "${aws_ecr_repository.contracts.repository_url}:latest",
    "resourceRequirements": [
      {"type": "VCPU", "value": "0.5"},
      {"type": "MEMORY", "value": "1"}
    ],
    "executionRoleArn": "${aws_iam_role.task_exec.arn}",
    "jobRoleArn": "${aws_iam_role.service.arn}"
  }
  CONTAINER_PROPERTIES

  timeout {
    // Timeout after 10 minutes
    attempt_duration_seconds = 60 * 10
  }
}

#
#  IAM Roles and Policies
#
resource "aws_iam_role" "service" {
  name               = "${local.project}-demo-servicerole"
  assume_role_policy = var.assume_role_policy_ecs
}

resource "aws_iam_role" "task_exec" {
  name               = "${local.project}-demo-taskexecutionrole"
  assume_role_policy = var.assume_role_policy_ecs
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
