resource "aws_iam_role" "role" {
  name = "${var.prefix}-tf-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = ["cognito-idp.amazonaws.com", "lambda.amazonaws.com"]
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "test-attach" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.role.name
  policy_arn = var.policy_arns[count.index]
}
