# api_key_required = false, so this is without any verification. 
# This document is the most basic.
# In modules 1-api-key, 0-5 is required, 6 is optional.

# call api-key module
module "api-key" {
  source = "../modules/1-api-key"

  # variables
  prefix = "without-api-key"
  object = [
    { resourceName = "health", methodName = "GET" },
    { resourceName = "product", methodName = ["GET", "POST", "PATCH", "DELETE"] },
    { resourceName = "products", methodName = "GET" }
  ]
  api_key_required = false
}


# output api endpoint url
output "view" {
  value = module.api-key.api-endpoint
}

