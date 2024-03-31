variable "prefix" {}
variable "app_domain" {}
variable "client_id" {}
variable "client_secret" {}

variable "policy_arns" {
  default = ["arn:aws:iam::aws:policy/AmazonSNSFullAccess"]
}
variable "allowed_oauth_flows" {}
variable "supported_identity_providers" {}



