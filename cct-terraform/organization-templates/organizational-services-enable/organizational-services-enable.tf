locals {
  common_tags = {
    Purpose = "caylent-accelerator"
    CreatedBy = "Caylent"
    ManagedBy = "control-tower-pipeline"
  }
}

##########################################
# Lambda Function 
##########################################
resource "aws_lambda_function" "enable_organizational_service_lambda" {

  filename      = "ose_lambda.zip"
  function_name = "caylent-org-service-enable-lambda"
  description   = "Caylent accelerator function - enables EBS encryption by default in all regions"
  handler       = "ose_lambda.handler"
  runtime       = "python3.9"
  role          = aws_iam_role.enable_organizational_service_lambda_execution_role.arn
  timeout       = 60
  environment {
    variables = {
      Region    = "${data.aws_region.current.name}",
      EnableOrganizationalService   = var.enable_organization_service,
      ServiceAdministratorAccount = var.service_admin_account,
    }
  }
  tags = local.common_tags
}

############################################################
# Invoke Lambda - lambda to enable ebs encryption by default
#   Lambda will run on creation
############################################################
data "aws_lambda_invocation" "ebs_encryption" {
  function_name = aws_lambda_function.enable_organizational_service_lambda.function_name

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
resource "aws_iam_role" "enable_organizational_service_lambda_execution_role" {
  name               = "caylent-org-service-enable-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name   = "root"
    policy = data.aws_iam_policy_document.root.json
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

data "aws_iam_policy_document" "root" {
  statement {
    actions   = [
        "organizations:EnableAWSServiceAccess",
        "organizations:ListAWSServiceAccessForOrganization",
        "organizations:RegisterDelegatedAdministrator",
        "organizations:ListDelegatedAdministrators",
        "organizations:DescribeOrganizationalUnit",
        "organizations:DescribeAccount",
        "organizations:DescribeOrganization",
        "ec2:DescribeRegions",
        "guardduty:EnableOrganizationAdminAccount"
      ]
    resources = ["*"]
  }
}

##################################
# CloudWatch Log Group for Lambda
##################################
resource "aws_cloudwatch_log_group" "os_lamda_log" {
  name              = "/aws/lambda/${aws_lambda_function.enable_organizational_service_lambda.function_name}"
  retention_in_days = 7
  tags = local.common_tags
}
