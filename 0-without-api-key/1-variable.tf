variable "policy_arns" {
  default = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  ]
}

variable "object" {
  default = [
    { resourceName = "health", methodName = "GET" },
    { resourceName = "product", methodName = ["GET", "POST", "PATCH", "DELETE"] },
    { resourceName = "products", methodName = "GET" }
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
# flatten-object output
# [
#   {
#     "methodName" = "GET"
#     "resourceName" = "health"
#   },
#   {
#     "methodName" = "GET"
#     "resourceName" = "product"
#   },
#   {
#     "methodName" = "POST"
#     "resourceName" = "product"
#   },
#   {
#     "methodName" = "PATCH"
#     "resourceName" = "product"
#   },
#   {
#     "methodName" = "DELETE"
#     "resourceName" = "product"
#   },
#   {
#     "methodName" = "GET"
#     "resourceName" = "products"
#   },
# ]
