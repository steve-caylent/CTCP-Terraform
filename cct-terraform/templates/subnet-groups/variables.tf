variable "create_db_subnet_group" {
  type            = string
  description     = "Create DB Subnet Group"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_db_subnet_group))
    error_message = "Must be true or false."
  }
}

variable "create_elasticache_subnet_group" {
  type            = string
  description     = "Create Elasticache Subnet Group"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_elasticache_subnet_group))
    error_message = "Must be true or false."
  }
}

variable "private_subnet_ids" {
  default     = "/caylent/vpc/private/subnets/id"
  description = "Select the subnets to associate with the VPC endpoint"
}


