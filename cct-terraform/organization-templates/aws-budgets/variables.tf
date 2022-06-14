variable "budget_name" {
  default     = "accelerator-account-budget-alert-topic"
  description = "AWS Budget Name"
}

variable "budget_limit" {
  default     = 5000
  description = "Set budget limit"
}

variable "time_unit" {
  default     = "MONTHLY"
  description = "Allowed values: ANNUALLY | DAILY | MONTHLY | QUARTERLY"
}

variable "comparison_operator" {
  default     = "GREATER_THAN"
  description = "Allowed values: EQUAL_TO | GREATER_THAN | LESS_THAN"
}

variable "budget_threshold" {
  default     = 80
  description = "Set the value of the budget threshold"
}

variable "threshold_type" {
  default     = "PERCENTAGE"
  description = "Allowed values: ABSOLUTE_VALUE | PERCENTAGE"
}

variable "notification_type" {
  default     = "ACTUAL"
  description = "Allowed values: ACTUAL | FORECASTED"
}

variable "budget_alert_subscriber" {
  default     = "email@example.com"
  description = "Email addresses for notification"

}

variable "cost_filters_service" {
  description = "Budget service cost filter. Allowed values: Amazon Elastic Compute Cloud - Compute / Amazon Relational Database Service / Amazon Redshift / Amazon ElastiCache/ Amazon Elasticsearch Service"
  type        = string
  default     = "Amazon Elastic Compute Cloud - Compute"
}