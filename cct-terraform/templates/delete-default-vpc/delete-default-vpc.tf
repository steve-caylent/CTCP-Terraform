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
resource "aws_lambda_function" "delete_default_vpc_lambda_function" {

  filename      = "index.zip"
  function_name = "caylent-delete-default-vpc"
  description   = "Caylent accelerator function - Deletes the default VPC"
  role          = aws_iam_role.delete_default_vpc_lambda_execution_role.arn
  handler       = "index.handler"
  timeout       = 300
  runtime       = "python3.9"
  tags = local.common_tags
}

############################################################
# Invoke Lambda - lambda to delete default VPC in all regions
#   Lambda will run on creation
############################################################
data "aws_lambda_invocation" "delete_default_vpc" {
  function_name = aws_lambda_function.delete_default_vpc_lambda_function.function_name

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

##################################
# IAM Role for Lambda
#   Assume Role Policy
#   Managed Role Policy
#   One Inline Policy
##################################
resource "aws_iam_role" "delete_default_vpc_lambda_execution_role" {
  name                = "caylent-delete-default-vpc-lambda-role"
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
        "ec2:DescribeRegions",
        "ec2:DescribeVpcs",
        "ec2:DescribeNatGateways",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeSubnets",
        "ec2:DeleteVpc",
        "ec2:DeleteNatGateway",
        "ec2:DeleteInternetGateway",
        "ec2:DeleteSubnet",
        "ec2:DetachInternetGateway"
      ]
    resources = ["*"]
  }
}

##################################
# CloudWatch Log Group for Lambda
##################################
resource "aws_cloudwatch_log_group" "os_lamda_log" {
  name              = "/aws/lambda/${aws_lambda_function.delete_default_vpc_lambda_function.function_name}"
  retention_in_days = 7
  tags = local.common_tags
}
