variable "session_duration" {
  default     = "PT8H"
  description = "Enter time in ISO8601 standard. PT8H is 8 hours"
}

variable "role_prefix" {
  default     = "Caylent"
  description = "Prefix for the permissions set name"
  
}
