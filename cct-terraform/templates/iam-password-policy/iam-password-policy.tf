locals {
  iam_options = {
    minimum_password_length        = var.minimum_password_length
    require_symbols                = var.require_symbols
    require_numbers                = var.require_numbers
    require_uppercase_characters   = var.require_uppercase_characters
    require_lowercase_characters   = var.require_lowercase_characters
    allow_users_to_change_password = var.allow_users_to_change_password
    hard_expiry                    = var.hard_expiry
    password_reuse_prevention      = var.password_reuse_prevention
    max_password_age               = var.max_password_age
  }
}

resource "aws_iam_account_password_policy" "strict" {
  minimum_password_length        = local.iam_options.minimum_password_length
  require_symbols                = local.iam_options.require_symbols
  require_numbers                = local.iam_options.require_numbers
  require_uppercase_characters   = local.iam_options.require_uppercase_characters
  require_lowercase_characters   = local.iam_options.require_lowercase_characters
  allow_users_to_change_password = local.iam_options.allow_users_to_change_password
  hard_expiry                    = local.iam_options.hard_expiry
  password_reuse_prevention      = local.iam_options.password_reuse_prevention
  max_password_age               = local.iam_options.max_password_age
}



