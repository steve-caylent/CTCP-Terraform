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
resource "aws_lambda_function" "ebs_encryption_by_default_lambda_function" {

  filename      = "index.zip"
  function_name = "caylent-ebs-encryption-by-default"
  description   = "Caylent accelerator function - enables EBS encryption by default in all regions"
  role          = aws_iam_role.ebs_encryption_by_default_lambda_execution_role.arn
  handler       = "index.handler"
  timeout       = 60
  runtime       = "python3.9"
  tags = local.common_tags
  environment {
    variables = {
      Region_List    = var.region_list,
    }
  }
}

############################################################
# Invoke Lambda - lambda makes ebs encryption by default
#   Lambda will run on creation
############################################################
data "aws_lambda_invocation" "ebs_encryption_by_default" {
  function_name = aws_lambda_function.ebs_encryption_by_default_lambda_function.function_name

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
data "aws_ebs_encryption_by_default" "current" {}

##################################
# IAM Role for Lambda
#   Assume Role Policy
#   Managed Role Policy
#   One Inline Policy
##################################
resource "aws_iam_role" "ebs_encryption_by_default_lambda_execution_role" {
  name                = "caylent-ebs-encryption-by-default-lambda-role"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = ["arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]

  inline_policy {
    name   = "root"
    policy = data.aws_iam_policy_document.root.json
  }
  tags                = local.common_tags
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
        "ec2:DisableEbsEncryptionByDefault",
        "ec2:EnableEbsEncryptionByDefault",
        "ec2:GetEbsDefaultKmsKeyId",
        "ec2:GetEbsEncryptionByDefault",
        "ec2:ModifyEbsDefaultKmsKeyId",
        "ec2:ResetEbsDefaultKmsKeyId",
        "ec2:DescribeRegions"
      ]
    resources = ["*"]
  }
}

##################################
# CloudWatch Log Group for Lambda
##################################
resource "aws_cloudwatch_log_group" "os_lamda_log" {
  name              = "/aws/lambda/${aws_lambda_function.ebs_encryption_by_default_lambda_function.function_name}"
  retention_in_days = 7
  tags = local.common_tags
}

