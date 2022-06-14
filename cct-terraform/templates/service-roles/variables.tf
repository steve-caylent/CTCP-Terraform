
variable "ec2_role_name" {
  type            = string
  description     = "EC2 instance role name"
  default         = "ec2-profile-role"
}

variable "lambda_role_name" {
  type            = string
  description     = "Lambda role name"
  default         = "lambda-service-role"
}

variable "create_lambda_role" {
  type            = string
  description     = "Create role for aws lambda"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_lambda_role))
    error_message = "Must be true or false."
  }
}

variable "create_ec2_instance_profile" {
  type            = string
  description     = "Create EC2 instance profile"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_ec2_instance_profile))
    error_message = "Must be true or false."
  }
}