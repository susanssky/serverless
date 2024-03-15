# data "aws_api_gateway_resource" "my_resource" {
#   count       = length(var.policy_arns)
#   rest_api_id = aws_api_gateway_rest_api.api.id
#   path        = "/${var.resource[count.index]}"
# }

# output "view" {
#   value      = aws_api_gateway_stage.api-gateway-stage.invoke_url
#   depends_on = [aws_api_gateway_stage.api-gateway-stage]
# }
# # data "aws_iam_role" "example" {
# #   name = "serverless-api-role"
# # }
# output "view2" {
#   value = data.aws_api_gateway_rest_api.my_rest_api
# }
