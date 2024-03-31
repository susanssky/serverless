variable "prefix" {
  # because aws_cognito_user_pool_domain cannot contain reserved word: cognito
  default = "google-c-ognito-lambda-auth"
}

variable "app_domain" {
  default = "http://localhost:5500/4-cognito"
}

variable "file_name" {
  default = ["home"]
}

variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]
}

variable "object" {
  default = [
    { resourceName : "users", methodName : "GET" }
  ]
}
locals {
  flatten-object = flatten([
    for obj in var.object : [
      for method in(
        try(tolist(obj.methodName), [obj.methodName])
        ) : {
        resourceName = obj.resourceName
        methodName   = method
      }
    ]
  ])
}
