
# (add trigger) in lambda
resource "aws_lambda_permission" "apigw_lambda" {
  # statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*"
}

resource "aws_api_gateway_deployment" "api-gateway-deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.method, aws_api_gateway_integration.integration]
}
resource "aws_api_gateway_stage" "api-gateway-stage" {
  deployment_id = aws_api_gateway_deployment.api-gateway-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}
