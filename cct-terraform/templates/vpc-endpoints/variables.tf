variable "param_vpc_id" {
  type            = string
  description     = "Select the VPC ID for the VPC endpoint"
  default         = "/caylent/vpc/id"
}

variable "param_vpc_cidr" {
  type            = string
  description     = "Select the VPC ID for the VPC endpoint"
  default         = "/caylent/vpc/cidr"
}

variable "param_subnet_ids" {
  type            = string
  description     = "Select the subnets to associate with the VPC endpoint"
  default         = "/caylent/vpc/private/subnets/id"
}

variable "route_table" {
  type            = string
  description     = "Route table to associate with endpoint"
  default         = "/caylent/vpc/services/routetable/id"
}


variable "create_ssm_endpoint" {
  type            = string
  description     = "Create Endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_ssm_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_ssm_messages_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_ssm_messages_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_ec2_messages_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_ec2_messages_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_cloudwatch_logs_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_cloudwatch_logs_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_sns_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_sns_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_sqs_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_sqs_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_cloudwatch_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_cloudwatch_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_cloudformation_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_cloudformation_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_s3_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_s3_endpoint))
    error_message = "Must be true or false."
  }
}

variable "create_dynamodb_endpoint" {
  type            = string
  description     = "Need ssm endpoint"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_dynamodb_endpoint))
    error_message = "Must be true or false."
  }
}

variable "bucketname" {
  type            = string
  description     = "S3 Bucket Name for Endpoint"
  default         = "/caylent/vpc/id"
}