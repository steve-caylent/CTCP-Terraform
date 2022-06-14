variable "create_kms_cmks" {
  type            = string
  description     = "Create kms Customer Master Keys"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.create_kms_cmks))
    error_message = "Must be true or false."
  }
}

variable "compliance_kms_cmks" {
  type            = string
  description     = "Create key for compliance"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.compliance_kms_cmks))
    error_message = "Must be true or false."
  }
}

variable "compliance_key_rotation" {
  type            = string
  description     = "Enable automatic key rotation"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.compliance_key_rotation))
    error_message = "Must be true or false."
  }
}

variable "compliance_multiregion_key" {
  type            = string
  description     = "Make key multiregion"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.compliance_multiregion_key))
    error_message = "Must be true or false."
  }
}

variable "compliance_principal" {
  type            = string
  description     = "Provide User IAM"
  default         = ""
}

variable "service_kms_cmks" {
  type            = string
  description     = "Create key for aws service"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.service_kms_cmks))
    error_message = "Must be true or false."
  }
}

variable "service_key_rotation" {
  type            = string
  description     = "Enable automatic key rotation"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.service_key_rotation))
    error_message = "Must be true or false."
  }
}

variable "service_multiregion_key" {
  type            = string
  description     = "Make key multiregion"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.service_multiregion_key))
    error_message = "Must be true or false."
  }
}

variable "service_principal" {
  type            = string
  description     = "Provide Service Name"
  default         = ""
}

variable "application_kms_cmks" {
  type            = string
  description     = "Create key for application IAM"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.application_kms_cmks))
    error_message = "Must be true or false."
  }
}

variable "application_key_rotation" {
  type            = string
  description     = "Enable automatic key rotation"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.application_key_rotation))
    error_message = "Must be true or false."
  }
}

variable "application_multiregion_key" {
  type            = string
  description     = "Make key multiregion"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.application_multiregion_key))
    error_message = "Must be true or false."
  }
}

variable "application_principal" {
  type            = string
  description     = "Provide Application IAM"
  default         = ""
}

variable "team_kms_cmks" {
  type            = string
  description     = "Create key for Role"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.team_kms_cmks))
    error_message = "Must be true or false."
  }
}

variable "team_key_rotation" {
  type            = string
  description     = "Enable automatic key rotation"
  default         = "true"

  validation {
    condition     = can(regex("^(true|false)$", var.team_key_rotation))
    error_message = "Must be true or false."
  }
}

variable "team_multiregion_key" {
  type            = string
  description     = "Make key multiregion"
  default         = "false"

  validation {
    condition     = can(regex("^(true|false)$", var.team_multiregion_key))
    error_message = "Must be true or false."
  }
}

variable "team_principal" {
  type            = string
  description     = "Provide Role Name"
}