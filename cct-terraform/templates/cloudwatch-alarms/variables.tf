variable "log_group_name" {
  default     = "aws-controltower/CloudTrailLogs"
}

variable "metric_namespace" {
  default     = "caylent-acclerator"
}

variable "sec_alert_sns_topic" {
  default     = "/caylent/sec-alerts-sns-topic"
  description = "Security Alert SNS topic - Paramter store value is default"
}