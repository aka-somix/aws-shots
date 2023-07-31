
resource "aws_cloudwatch_event_target" "submit_contracts_batch_job" {
  rule      = aws_cloudwatch_event_rule.on_contract_batch_upload.name
  arn       = aws_batch_job_queue.demo.arn
  target_id = "SubmitCustomBatchJob"
  role_arn  = "TODO"

  batch_target {
    job_definition = aws_batch_job_definition.demo.arn
    job_name       = "${local.project}-job-from-eventbridge"
  }

  # Override command
  input_transformer {
    input_paths = {
      object_uploaded = "$.detail.requestParameters.key"
    }
    input_template = <<JSON
{
  "ContainerOverrides": {
    "Environment": ["python3", "src/main.py", "<object_uploaded>"]
  }
}
JSON
  }
}

