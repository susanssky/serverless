resource "aws_api_gateway_authorizer" "api-gateway-authorizer" {
  name                             = "my-authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.api.id
  type                             = "COGNITO_USER_POOLS"
  identity_source                  = "method.request.header.auth-token"
  authorizer_result_ttl_in_seconds = 0
  provider_arns                    = [aws_cognito_user_pool.cognito-pool.arn]
  depends_on                       = [aws_cognito_user_pool.cognito-pool]
}
