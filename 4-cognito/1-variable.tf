variable "prefix" {
  # because aws_cognito_user_pool_domain cannot contain reserved word: cognito
  default = "only-c-ognito"
}

variable "app_domain" {
  default = "http://localhost:5500/4-cognito"
}

variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess"
  ]
}
