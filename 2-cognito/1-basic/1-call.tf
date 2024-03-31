# without any provider (e.g. Google login)
# This document is the most basic.

# call cognito module
module "cognito" {
  source = "../modules"

  # variables
  prefix                       = "without-google"
  app_domain                   = "http://localhost:5500/2-cognito/modules"
  client_id                    = "00000000000000000.apps.googleusercontent.com"
  client_secret                = "GOCSPX-000000000000000000000"
  allowed_oauth_flows          = ["code"]
  supported_identity_providers = ["COGNITO"]
}


output "links" {
  value = {
    "logged-in-url"  = module.cognito.logged-in-link,
    "logged-out-url" = module.cognito.logged-out-link
  }
}

