resource "aws_dynamodb_table" "dynamodb-table" {
  name                        = "${var.prefix}-product-inventory"
  billing_mode                = "PROVISIONED"
  read_capacity               = 5
  write_capacity              = 5
  hash_key                    = "productId"
  deletion_protection_enabled = false

  attribute {
    name = "productId"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}


# resource "aws_dynamodb_table" "basic-dynamodb-table" {
#   name           = "read_capacity"
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 5
#   write_capacity = 5
#   hash_key       = "UserId"
#   range_key      = "GameTitle"

#   attribute {
#     name = "UserId"
#     type = "S"
#   }

#   attribute {
#     name = "GameTitle"
#     type = "S"
#   }

#   attribute {
#     name = "TopScore"
#     type = "N"
#   }

#   ttl {
#     attribute_name = "TimeToExist"
#     enabled        = false
#   }

#   global_secondary_index {
#     name               = "GameTitleIndex"
#     hash_key           = "GameTitle"
#     range_key          = "TopScore"
#     write_capacity     = 10
#     read_capacity      = 10
#     projection_type    = "INCLUDE"
#     non_key_attributes = ["UserId"]
#   }

#   tags = {
#     Name        = "dynamodb-table-1"
#     Environment = "production"
#   }
# }
