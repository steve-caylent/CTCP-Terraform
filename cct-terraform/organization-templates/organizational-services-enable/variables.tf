variable "enable_organization_service" {
  default     = "true"
  description = "Enable organization service. true | false"
}

variable "service_admin_account" {
  default     = "account12345"
  description = "The account id of the account to delegate as the administrator. This is typically the audit account"
  
  validation {
      condition = length(var.service_admin_account) == 12 && length(regexall("[^[0-9]{12}$]", var.service_admin_account)) == 0    
      error_message = "The account id must be 12 characters, and only contain letters, numbers, and hyphens."
    }  
}
