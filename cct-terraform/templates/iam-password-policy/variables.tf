variable "allow_users_to_change_password" {
  type            = string
  description     = "Allow user to change passowrd"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.allow_users_to_change_password))
    error_message = "Must be true or false."
  }
}

variable "hard_expiry" {
  type            = string
  description     = "You can prevent IAM users from choosing a new password after their current password has expired"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.hard_expiry))
    error_message = "Must be true or false."
  }
}

variable "max_password_age" {
  type            = number
  description     = "You can set IAM user passwords to be valid for only the specified number of days. Choose 0 if you don't not want passwords to expire"
  default         = 0

  validation {
    condition     = var.max_password_age >= 0 && var.max_password_age <= 1095
    error_message = "Must be in the range 0-1095."
  }
}

variable "minimum_password_length" {
  type            = number
  description     = "You can specify the minimum number of characters allowed in an IAM user password"
  default         = 8


  validation {
    condition     = var.minimum_password_length >= 6 && var.minimum_password_length <= 128
    error_message = "Must be in the range 6-128."
  }
}

variable "password_reuse_prevention" {
  type            = number
  description     = "You can prevent IAM users from reusing a specified number of previous passwords"
  default         = 24

  validation {
    condition     = var.password_reuse_prevention >= 0 && var.password_reuse_prevention <= 24
    error_message = "Must be in the range 0-24."
  }
}

variable "require_lowercase_characters" {
  type            = string
  description     = "You can require that IAM user passwords contain at least one lowercase character from the ISO basic Latin alphabet (a to z)"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.require_lowercase_characters))
    error_message = "Must be true or false."
  }
}

variable "require_numbers" {
  type            = string
  description     = "You can require that IAM user passwords contain at least one numeric character (0 to 9)"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.require_numbers))
    error_message = "Must be true or false."
  }
}

variable "require_symbols" {
  type            = string
  description     = "You can require that IAM user passwords contain at least one of the following nonalphanumeric characters: ! @ # $ % ^ & * ( ) _ + - = [ ] {} |"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.require_symbols))
    error_message = "Must be true or false."
  }
}

variable "require_uppercase_characters" {
  type            = string
  description     = "You can require that IAM user passwords contain at least one uppercase character from the ISO basic Latin alphabet (A to Z)"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.require_uppercase_characters))
    error_message = "Must be true or false."
  }
}