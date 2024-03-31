variable "prefix" {
  default = "with-auth"
}

variable "file_name" {
  default = ["home", "auth"]
}

variable "policy_arns" {
  default = [
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
