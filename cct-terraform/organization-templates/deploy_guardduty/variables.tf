
variable "guard_duty_delegated_admin_account" {
  default     = "accountid013"
  description = "The Amazon GuardDuty master account ID"
  
  validation {
      condition = length(var.guard_duty_delegated_admin_account) == 12 && length(regexall("[^[0-9]{12}$]", var.guard_duty_delegated_admin_account)) == 0    
      error_message = "The account id must be 12 characters, and only contain letters, numbers, and hyphens."
    }  
}


variable "organization_id" {
  default     = "o-0123456789"
  description = "The Amazon Organizations ID for the Control Tower"

  validation {
      condition = length(var.organization_id) == 12 && length(regexall("[^[o][-][a-z0-9]{10}$]", var.organization_id)) == 0    
      error_message = "The Org Id must be a 12 character string starting with o- and followed by 10 lower case alphanumeric characters."
    }
}

variable "gd_lambda_s3_bucket" {
  default     = "aws-service-catalog-reference-architectures"
  description = "The S3 bucket that contains the lambda solution file"
}

variable "gd_lambda_s3_key" {
  default     = "security/guardduty/function.zip"
  description = "The S3 path to the lambda solution file"
}

variable "guard_duty_role_assume" {
  default     = "AWSControlTowerExecution"
  description = "What role should be assumed in child accounts to enable GuardDuty?  The default is AWSControlTowerExecution for a control tower environment"
}