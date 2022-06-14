locals {
  common_tags = {
    Purpose = "caylent-accelerator"
    CreatedBy = "Caylent"
    ManagedBy = "control-tower-pipeline"
  }
}


##########################################
# SNS topic for Security
##########################################
resource "aws_sns_topic" "sns_topic" {
  name              = "caylent-sec-alerts"
  kms_master_key_id = "alias/aws/sns"
  tags              = local.common_tags
}

##########################################
# SNS Subscription for Security
##########################################
resource "aws_sns_topic_subscription" "sns_topic_subscription" {
  topic_arn = aws_sns_topic.sns_topic.arn
  protocol          = "email"
  endpoint          = var.sec_alert_email_address
}

##########################################
# SNS Policy
##########################################
resource "aws_sns_topic_policy" "sns_policy" {
  arn = aws_sns_topic.sns_topic.arn

  policy = data.aws_iam_policy_document.sec_alert_policy.json
}

##########################################
# SNS Policy - Policy Document
##########################################
data "aws_iam_policy_document" "sec_alert_policy" {
  statement {
    sid = "AllowServices"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.sns_topic.arn,
      ]
  }
}

##########################################
# SSM Parameter - SNS Topic
##########################################
resource "aws_ssm_parameter" "sns_topic_parameter" {
  name  = "/caylent/sec-alerts-sns-topic"
  type  = "String"
  value = aws_sns_topic.sns_topic.arn
}