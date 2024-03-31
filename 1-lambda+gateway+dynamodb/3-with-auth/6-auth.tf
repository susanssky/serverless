resource "aws_api_gateway_authorizer" "api-gateway-authorizer" {
  name           = "my-authorizer-lambda"
  rest_api_id    = aws_api_gateway_rest_api.api.id
  authorizer_uri = aws_lambda_function.lambda-function[index(var.file_name, "auth")].invoke_arn
  # authorizer_credentials           = aws_iam_role.role.arn
  identity_source                  = "method.request.header.auth-token"
  authorizer_result_ttl_in_seconds = 0

}
