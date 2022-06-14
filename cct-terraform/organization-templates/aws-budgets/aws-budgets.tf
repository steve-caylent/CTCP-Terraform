
##########################################
# Locals - Tags, email
##########################################

locals {
  common_tags = {
    Purpose = "caylent-accelerator"
    CreatedBy = "Caylent"
    ManagedBy = "control-tower-pipeline"
  }
}


##########################################
# AWS Budget
##########################################
resource "aws_budgets_budget" "account_budget" {
  name              = var.budget_name
  depends_on        = [var.budget_alert_subscriber]
  budget_type       = "COST"
  limit_amount      = var.budget_limit
  limit_unit        = "USD"
  time_unit         = var.time_unit


  cost_filters = {
    Service = var.cost_filters_service
  }


  notification {
    comparison_operator        = var.comparison_operator
    threshold                  = var.budget_threshold
    threshold_type             = var.threshold_type
    notification_type          = var.notification_type
    subscriber_email_addresses = [var.budget_alert_subscriber]
  }
}


##########################################
# SNS topic for Budget
##########################################
resource "aws_sns_topic" "budget_update" {
  name = var.budget_name
  tags = local.common_tags
}

##########################################
# SNS Subscription for Budget
##########################################
resource "aws_sns_topic_subscription" "budget_topic_subscription" {
  topic_arn = aws_sns_topic.budget_update.arn
  protocol          = "email"
  endpoint          = var.budget_alert_subscriber
}

##########################################
# SNS Policy
##########################################
resource "aws_sns_topic_policy" "budget" {
  arn = aws_sns_topic.budget_update.arn

  policy = data.aws_iam_policy_document.budget_policy.json
}

##########################################
# SNS Policy - Policy Document
##########################################
data "aws_iam_policy_document" "budget_policy" {
  statement {
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["budgets.amazonaws.com"]
    }
    resources = [
      aws_sns_topic.budget_update.arn,
      ]
  }
}


