resource "aws_iam_role" "role" {
  name = "${var.prefix}-lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = var.policy_arns[count.index]
}

data "archive_file" "dynamodb_stream_lambda_function" {
  type        = "zip"
  source_file = "../modules/1-api-key/index.js"
  output_path = "../modules/1-api-key/index.zip"
}

resource "aws_lambda_function" "lambda-function" {
  function_name = "${var.prefix}-lambda-fn"
  # s3_bucket     = aws_s3_bucket.lambda_bucket.id
  # s3_key        = "lambdademo.zip"
  filename = data.archive_file.dynamodb_stream_lambda_function.output_path
  # source_code_hash = filebase64sha256("lambda_function_payload.zip")
  handler = "index.handler"
  role    = aws_iam_role.role.arn
  runtime = "nodejs16.x"
  # vpc_config {
  #   subnet_ids         = [aws_subnet.example.id]
  #   security_group_ids = [aws_security_group.example.id]
  # }
}

resource "aws_cloudwatch_log_group" "lambda-cloudwatch" {
  name              = "/aws/lambda/${aws_lambda_function.lambda-function.function_name}"
  retention_in_days = 1
}

data "aws_iam_policy_document" "example" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.lambda-cloudwatch.arn,
      "${aws_cloudwatch_log_group.lambda-cloudwatch.arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda-role-policy" {
  policy = data.aws_iam_policy_document.example.json
  role   = aws_iam_role.role.id
  name   = "${var.prefix}-my-lambda-policy"
}
