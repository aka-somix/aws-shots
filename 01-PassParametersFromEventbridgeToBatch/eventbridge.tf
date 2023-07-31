resource "aws_cloudwatch_event_rule" "demo" {
  name        = "${local.project}-submit-job-rule"
  description = ""
  is_enabled  = true

  # Pattern of the event
  # In this case we want to detect events generated with a source tag
  # that indicates this demo project (source= aws-shot-1)
  event_pattern = jsonencode({
    source = [local.project]
  })
}

resource "aws_cloudwatch_event_target" "submit_contracts_batch_job" {
  rule      = aws_cloudwatch_event_rule.demo.name
  arn       = aws_batch_job_queue.demo.arn
  target_id = "SubmitCustomBatchJob"
  role_arn  = aws_iam_role.eventbridge_to_batch.arn

  batch_target {
    job_definition = aws_batch_job_definition.demo.arn
    job_name       = "${local.project}-job-from-eventbridge"
  }

  # Override command
  input_transformer {
    input_paths = {
      source  = "$.detail.source",
      message = "$.detail.message"
    }
    input_template = <<JSON
{
  "ContainerOverrides": {
    "Environment": [
      {
        "name": "SOURCE",
        "value": "<source>"
      },
      {
        "name": "MESSAGE",
        "value": "<message>"
      }
    ]
  }
}
JSON
  }
}


#
# IAM Role and permission policies for submitting Batch Jobs
# 
resource "aws_iam_role" "eventbridge_to_batch" {
  name               = "${local.project}-ebtobatch"
  assume_role_policy = data.aws_iam_policy_document.events_assumerole.json
}

data "aws_iam_policy_document" "events_assumerole" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "batch_target_role" {
  role       = aws_iam_role.eventbridge_to_batch.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceEventTargetRole"
}
