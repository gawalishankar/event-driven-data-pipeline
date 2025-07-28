provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "raw_data" {
  bucket = "${var.project_name}-raw-data"
}

resource "aws_s3_bucket" "reports" {
  bucket = "${var.project_name}-reports"
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attach" {
  name       = "lambda-policy-attach"
  roles      = [aws_iam_role.lambda_exec_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "ingest_data" {
  function_name = "ingest-data"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  timeout       = 30
  filename      = "${path.module}/../lambda/ingest_data.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/ingest_data.zip")
}

resource "aws_lambda_function" "generate_report" {
  function_name = "generate-report"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60
  filename      = "${path.module}/../lambda/generate_report.zip"
  source_code_hash = filebase64sha256("${path.module}/../lambda/generate_report.zip")
}

resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "daily-report-trigger"
  schedule_expression = "rate(1 day)"
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "report-lambda"
  arn = aws_lambda_function.generate_report.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.generate_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_trigger.arn
}
