resource "aws_iam_role" "lambda-role" {
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
  role       = aws_iam_role.lambda-role.name
  policy_arn = var.policy_arns[count.index]
}

data "archive_file" "lambda-file" {
  count       = length(var.file_name)
  type        = "zip"
  source_file = "${var.file_name[count.index]}.mjs"
  output_path = "${var.file_name[count.index]}.zip"
}

resource "aws_lambda_function" "lambda-function" {
  count         = length(var.file_name)
  function_name = "${var.prefix}-lambda-${var.file_name[count.index]}-fn"
  filename      = data.archive_file.lambda-file[count.index].output_path
  handler       = "${var.file_name[count.index]}.handler"
  role          = aws_iam_role.lambda-role.arn
  runtime       = "nodejs18.x"
}

resource "aws_cloudwatch_log_group" "lambda-cloudwatch" {
  count             = length(var.file_name)
  name              = "/aws/lambda/${aws_lambda_function.lambda-function[count.index].function_name}"
  retention_in_days = 1
}

data "aws_iam_policy_document" "example" {
  count = length(var.file_name)
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.lambda-cloudwatch[count.index].arn,
      "${aws_cloudwatch_log_group.lambda-cloudwatch[count.index].arn}:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda-role-policy" {
  count  = length(var.file_name)
  policy = data.aws_iam_policy_document.example[count.index].json
  role   = aws_iam_role.lambda-role.id
  name   = "${var.prefix}-my-lambda-policy"
}
