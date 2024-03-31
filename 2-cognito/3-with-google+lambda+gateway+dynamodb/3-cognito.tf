resource "aws_cognito_user_pool" "cognito-pool" {
  name = "${var.prefix}-app-user-pool"

  ## Sign-in experience
  # Cognito user pool sign-in 
  username_attributes = ["email"]

  # Password policy 
  password_policy {
    minimum_length    = 8
    require_numbers   = true
    require_lowercase = true
  }

  # User account recovery
  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }

  sms_configuration {
    external_id    = "example"
    sns_caller_arn = aws_iam_role.role.arn
  }

  ## Sign-up experience
  # Attribute verification and user account confirmation > Cognito-assisted verification and confirmation
  auto_verified_attributes = ["email"]

  # Attribute verification and user account confirmation > Verifying attribute changes
  user_attribute_update_settings {
    attributes_require_verification_before_update = ["email"]
  }

  # Required attributes 
  # schema {
  #   attribute_data_type      = "String"
  #   name                     = "name"
  #   developer_only_attribute = false
  #   mutable                  = true
  #   required                 = false # if set false, this block === unexist, so have to set true if need
  #   string_attribute_constraints {
  #     max_length = 50
  #     min_length = 1
  #   }
  # }

  schema {
    attribute_data_type      = "String"
    name                     = "email"
    developer_only_attribute = false
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      max_length = 50
      min_length = 8
    }

  }

}
resource "aws_cognito_user_pool_domain" "main" {
  domain       = "${var.prefix}-domain"
  user_pool_id = aws_cognito_user_pool.cognito-pool.id
}

resource "aws_cognito_user_pool_client" "client" {
  name                                 = "${var.prefix}-client"
  user_pool_id                         = aws_cognito_user_pool.cognito-pool.id
  callback_urls                        = ["http://localhost:5500/4-cognito/logged_in.html"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["implicit"]
  allowed_oauth_scopes                 = ["email", "openid", "phone"]
  supported_identity_providers         = ["COGNITO", "Google"]
  logout_urls                          = ["http://localhost:5500/4-cognito/logged_out.html"]
  depends_on                           = [aws_cognito_identity_provider.example_provider]
}

resource "aws_cognito_identity_provider" "example_provider" {
  user_pool_id  = aws_cognito_user_pool.cognito-pool.id
  provider_name = "Google"
  provider_type = "Google"

  provider_details = {
    authorize_scopes = "email"
    client_id        = "00000000000000000.apps.googleusercontent.com"
    client_secret    = "GOCSPX-000000000000000000000"
  }

  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
}


