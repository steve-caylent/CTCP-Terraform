locals {
  common_tags = {
    Purpose = "caylent-accelerator"
    CreatedBy = "Caylent"
    ManagedBy = "control-tower-pipeline"
  }
}


##################################
# IAM Role for Lambda
#   Assume Role Policy
#   Three Inline Policies
##################################
resource "aws_iam_role" "lambda_execution_role" {
  count = var.create_lambda_role == "true" ? 1 : 0
  name                = var.lambda_role_name
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role_policy.json

  inline_policy {
    name   = "cloudwatch_policy"
    policy = data.aws_iam_policy_document.cloudwatch_policy.json
  }

  inline_policy {
    name   = "s3access_policy"
    policy = data.aws_iam_policy_document.s3access_policy.json
  }
  
  inline_policy {
    name   = "dynamoDB_policy"
    policy = data.aws_iam_policy_document.dynamoDB_policy.json
  }

  tags                = local.common_tags
}

##################################
# IAM Role for Server
#   Assume Role Policy
#   Three Managed Policies
#   Two Inline Policies
##################################
resource "aws_iam_role" "server_role" {
  count = var.create_ec2_instance_profile == "true" ? 1 : 0
  name                = var.lambda_role_name
  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/CloudWatchAgentAdminPolicy"
    ]

  inline_policy {
    name   = "cloudwatch_policy"
    policy = data.aws_iam_policy_document.cloudwatch_policy.json
  }

  inline_policy {
    name   = "s3access_policy"
    policy = data.aws_iam_policy_document.s3access_policy.json
  }

  tags                = local.common_tags
}

##################################
# EC2 Instance Profile
##################################
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  count = var.create_ec2_instance_profile == "true" ? 1 : 0
  name = "ec2-instance-profile"
  role = aws_iam_role.server_role.*.name[count.index]
}

##################################
# IAM Policies
#   2 Assume Roles- Lambda, EC2
#   S3 Access Policy
#   DB Policy
#   Cloudwatch Polict
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

data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_policy" {
  statement {
    actions   = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3access_policy" {
  statement {
    actions   = [
        "s3:PutObject",
        "s3:GetObject"
      ]
    resources = ["*"]
  }
  statement {
    actions   = [
        "s3:ListBucket"
      ]
    resources = ["*"]
  } 
}

data "aws_iam_policy_document" "dynamoDB_policy" {
  statement {
    actions   = [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem",
        "dynamodb:UpdateTable",
        "dynamodb:DescribeTable",
        "dynamodb:Query",
        "dynamodb:GetRecords"
      ]
    resources = ["*"]
  }
}




