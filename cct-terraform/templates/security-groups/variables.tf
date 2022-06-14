variable "vpc_id" {
  default     = ""
  description = "Select the VPC ID for the VPC endpoint"
}
    
variable "alb_group_name" {
  default     = ""
  description = "ALB Group Name"
}

variable "web_group_name" {
  default     = ""
  description = "Web Group Name"
}

variable "db_group_name" {
  default     = ""
  description = "DB Group Name"
}

variable "db_port" {
  type        = number
  default     = 5432
  description = "DB Port Number. Default is for Postgres"
}