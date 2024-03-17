resource "aws_api_gateway_rest_api" "api" {
  name = "${var.prefix}-serverless-api"
}

resource "aws_api_gateway_resource" "resource" {
  count       = length(var.object)
  path_part   = var.object[count.index].resourceName
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  count         = length(flatten(var.object[*].methodName))
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource[index(var.object[*].resourceName, local.flatten-object[count.index].resourceName)].id
  http_method   = local.flatten-object[count.index].methodName
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.api-gateway-authorizer.id
}


# Every method request must add an integration request. It must be added.
resource "aws_api_gateway_integration" "integration" {
  count                   = length(flatten(var.object[*].methodName))
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource[index(var.object[*].resourceName, local.flatten-object[count.index].resourceName)].id
  http_method             = aws_api_gateway_method.method[count.index].http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.lambda-function[index(var.file_name, "home")].invoke_arn
  # credentials             = aws_iam_role.lambda-role.arn
}

resource "aws_api_gateway_method_response" "method-response-200" {
  count       = length(flatten(var.object[*].methodName))
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[index(var.object[*].resourceName, local.flatten-object[count.index].resourceName)].id
  http_method = aws_api_gateway_method.method[count.index].http_method
  status_code = "200"
  # response_models = {
  #   "application/json" = "Empty"
  # }
}

resource "aws_api_gateway_integration_response" "integration-resoonse" {
  count       = length(flatten(var.object[*].methodName))
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource[index(var.object[*].resourceName, local.flatten-object[count.index].resourceName)].id
  http_method = aws_api_gateway_method.method[count.index].http_method
  status_code = aws_api_gateway_method_response.method-response-200[count.index].status_code
  # response_templates = {
  #   "application/json" = ""
  # }
  depends_on = [aws_api_gateway_integration.integration]
}
