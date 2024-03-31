# with Google login provider

# call cognito module
module "cognito" {
  source = "../modules"

  # variables
  prefix                       = "with-google"
  app_domain                   = "http://localhost:5500/2-cognito/modules"
  client_id                    = "00000000000000000.apps.googleusercontent.com"
  client_secret                = "GOCSPX-000000000000000000000"
  allowed_oauth_flows          = ["implicit"]
  supported_identity_providers = ["COGNITO", "Google"]
}

output "links" {
  value = {
    "logged-in-url"                 = module.cognito.logged-in-link,
    "logged-out-url"                = module.cognito.logged-out-link,
    "Authorised-JavaScript-origins" = module.cognito.Authorised-JavaScript-origins, "Authorised-redirect-URIs" = module.cognito.Authorised-redirect-URIs
  }
}
