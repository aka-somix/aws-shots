

resource "aws_cloudwatch_event_target" "submit_contracts_batch_job" {
  rule      = aws_cloudwatch_event_rule.on_contract_batch_upload.name
  arn       = var.ingestion_queue.arn
  target_id = "SubmitContractsBatchJob"
  role_arn  = var.aws_iam_role_batch_job_submitter.arn

  batch_target {
    job_definition = aws_batch_job_definition.history_ingestion.arn
    job_name       = local.job_name
  }

  # Override command
  input_transformer {
    input_paths = {
      object_uploaded = "$.detail.requestParameters.key"
    }
    input_template = <<JSON
{
  "ContainerOverrides": {
    "Command": ["python3", "src/main.py", "<object_uploaded>"]
  }
}
JSON
  }
}

