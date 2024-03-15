variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]
}


variable "object" {
  default = [
    { resourceName : "products", methodName : "GET" },
    { resourceName : "product", methodName : "POST" }
  ]
}
