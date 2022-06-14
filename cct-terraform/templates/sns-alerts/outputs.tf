output "sns_topic" {
  value         = aws_sns_topic.sns_topic.arn
  description   = "SNS Topic for security alerts"
}
