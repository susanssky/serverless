# for logging in
output "logged-in-link" {
  value = "https://${aws_cognito_user_pool_domain.main.domain}.auth.eu-west-2.amazoncognito.com/login?client_id=${aws_cognito_user_pool_client.client.id}&response_type=${contains(aws_cognito_user_pool_client.client.allowed_oauth_flows, "implicit") ? "token" : "code"}&scope=${join("+", aws_cognito_user_pool_client.client.allowed_oauth_scopes)}&redirect_uri=${var.app_domain}/logged_in.html"
}

# for logging out
output "logged-out-link" {
  value = "https://${aws_cognito_user_pool_domain.main.domain}.auth.eu-west-2.amazoncognito.com/logout?client_id=${aws_cognito_user_pool_client.client.id}&logout_uri=${var.app_domain}/logged_out.html"
}

output "api-endpoint-for-logging" {
  value      = "${aws_api_gateway_stage.api-gateway-stage.invoke_url}/${aws_api_gateway_resource.resource[0].path_part}"
  depends_on = [aws_api_gateway_stage.api-gateway-stage]
}
