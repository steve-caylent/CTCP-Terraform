##########################################
# Lambda Function 
##########################################
resource "aws_lambda_function" "enable_GD_delegated_admin_lambda" {

  s3_bucket     = var.gd_lambda_s3_bucket
  s3_key        = var.gd_lambda_s3_key
  function_name = "GuardDutyAdminLambda"
  description   = "Creates a Lambda function to delegate GuardDuty master account in an AWS Organization"
  handler       = "index.handler"
  runtime       = "python3.8"
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.gd_admin_role.arn}"
  memory_size   = 128
  timeout       = 600
  environment {
    variables = {
      role_to_assume    = var.guard_duty_role_assume,
      ct_root_account   = "${data.aws_caller_identity.current.account_id}",
      gd_master_account = var.guard_duty_delegated_admin_account,
    }
  }
}

############################################################
# Invoke Lambda - enable guard duty, run first time
#   Lambda will run on creation
############################################################
data "aws_lambda_invocation" "gd_invoke" {
  function_name = aws_lambda_function.enable_GD_delegated_admin_lambda.function_name

  input = <<JSON
{
  "key1": "value1",
  "key2": "value2"
}
JSON
}

##################################
# Data Sources
##################################
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "your_org" {}

##################################
# IAM Role for Lambda
#   Assume Role Policy
#   One Inline Policy
##################################
resource "aws_iam_role" "gd_admin_role" {
  name               = "gd_admin_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  inline_policy {
    name   = "guard_duty-policy"
    policy = data.aws_iam_policy_document.gd_role.json
  }

}

##################################
# IAM Policies for Lambda
##################################
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "gd_role" {
  statement {
    actions   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/*"]
  }
  statement {
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::*:role/${var.guard_duty_role_assume}"]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgId"

      values = [
        "${data.aws_organizations_organization.your_org.arn}",
      ]
    }
  }
  statement {
    actions   = [
        "organizations:RegisterDelegatedAdministrator",
        "organizations:DescribeOrganization",
        "organizations:EnableAWSServiceAccess",
        "organizations:ListDelegatedAdministrators",
        "organizations:ListAWSServiceAccessForOrganization",
        "organizations:ListAccounts",
        "cloudtrail:DescribeTrails",
        "guardduty:DisableOrganizationAdminAccount",
        "guardduty:EnableOrganizationAdminAccount",
        "guardduty:ListDetectors",
        "guardduty:CreatePublishingDestination",
        "guardduty:CreateDetector",
        "guardduty:ListOrganizationAdminAccounts",
        "iam:CreateServiceLinkedRole"
      ]
    resources = ["*"]
  }
}




