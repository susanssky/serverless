resource "aws_api_gateway_api_key" "example" {
  name = "customer-1"
}
resource "aws_api_gateway_usage_plan" "example" {
  name         = "premium-plan"
  product_code = "MYCODE"

  api_stages {
    api_id = aws_api_gateway_rest_api.api.id
    stage  = aws_api_gateway_stage.api-gateway-stage.stage_name
  }
  throttle_settings {
    rate_limit  = 1000
    burst_limit = 500
  }

  quota_settings {
    limit = 1000000
    # offset = 2
    period = "MONTH"
  }
}
resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.example.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.example.id
}
