# api_key_required = true, so this is with api key
# In modules 1-api-key, 0-6 is required

# call basic module
module "api-key" {
  source = "../modules/1-api-key"

  # variables
  prefix = "with-api-key"
  object = [
    { resourceName : "products", methodName : "GET" },
    { resourceName : "product", methodName : "POST" }
  ]
  api_key_required = true
}

# output api endpoint url
output "view" {
  value = module.api-key.api-endpoint
}
