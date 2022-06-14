locals {
  common_tags = {
    Purpose = "caylent-accelerator"
    CreatedBy = "Caylent"
    ManagedBy = "control-tower-pipeline"
  }
}


##################################
# Data Sources
##################################
data "aws_region" "current" {}

data "aws_ssm_parameter" "param_vpc_id" {
  name = var.param_vpc_id
}

data "aws_ssm_parameter" "param_vpc_cidr" {
  name = var.param_vpc_cidr
}

data "aws_ssm_parameter" "param_subnet_ids" {
  name = var.param_subnet_ids
}

data "aws_ssm_parameter" "route_table" {
  name = var.route_table
}



##################################
# Endpoint Security Group
##################################
resource "aws_security_group" "endpoint_security_group" {
  name        = "endpoint-security-group"
  description = "Allow endpoint connections"
  vpc_id      = "${data.aws_ssm_parameter.param_vpc_id.value}"

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["${data.aws_ssm_parameter.param_vpc_cidr.value}"]
  }

  egress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["${data.aws_ssm_parameter.param_vpc_cidr.value}"]
  }
  tags = local.common_tags
}

##################################
# VPCE - SSM Endpoint
##################################
resource "aws_vpc_endpoint" "ssm_endpoint" {
  count = var.create_ssm_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.ssm"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - SSM Messages Endpoint
##################################
resource "aws_vpc_endpoint" "ssm_messages_endpoint" {
  count = var.create_ssm_messages_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.ssmmessages"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - EC2 Messages Endpoint
##################################
resource "aws_vpc_endpoint" "ec2_messages_endpoint" {
  count = var.create_ec2_messages_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.ec2messages"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - CloudWatch Logs Endpoint
##################################
resource "aws_vpc_endpoint" "cloudwatch_logs_endpoint" {
  count = var.create_cloudwatch_logs_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.logs"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - SNS Endpoint
##################################
resource "aws_vpc_endpoint" "sns_endpoint" {
  count = var.create_sns_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.sns"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - SQS Endpoint
##################################
resource "aws_vpc_endpoint" "sqs_endpoint" {
  count = var.create_sqs_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.sqs"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - CloudWatch Endpoint
##################################
resource "aws_vpc_endpoint" "cloudwatch_endpoint" {
  count = var.create_cloudwatch_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.monitoring"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - CloudFormation Endpoint
##################################
resource "aws_vpc_endpoint" "cloudformation_endpoint" {
  count = var.create_cloudformation_endpoint == "true" ? 1 : 0
  private_dns_enabled = true
  security_group_ids = [aws_security_group.endpoint_security_group.id]
  service_name = "com.amazonaws.${data.aws_region.current.name}.cloudformation"
  subnet_ids          = ["${data.aws_ssm_parameter.param_subnet_ids.value}"] 
  vpc_endpoint_type = "Interface"
  vpc_id       = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# VPCE - S3 Gateway Endpoint
##################################
resource "aws_vpc_endpoint" "s3_endpoint" {
  count = var.create_dynamodb_endpoint == "true" ? 1 : 0
  policy            = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
  route_table_ids   = ["${data.aws_ssm_parameter.route_table.value}"] 
  service_name      = "com.amazonaws.${data.aws_region.current.name}.dynamodb"
  vpc_id            = "${data.aws_ssm_parameter.param_vpc_id.value}"
}


##################################
# S3 Endpoint Policy
##################################
data "aws_iam_policy_document" "s3_endpoint_policy" {
  statement {
    actions = [
      "s3:GetObject",
    ]

    principals { 
      type        = "*"
      identifiers = ["*"]
    }

    resources = ["arn:aws:s3:::${var.bucketname}/*"]
  }
}

##################################
# VPCE - DynamoDB Gateway Endpoint
##################################
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  count = var.create_s3_endpoint == "true" ? 1 : 0
  policy            = data.aws_iam_policy_document.s3_endpoint_policy.json
  route_table_ids   = ["${data.aws_ssm_parameter.route_table.value}"] 
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_id            = "${data.aws_ssm_parameter.param_vpc_id.value}"
}

##################################
# DynamoDB Endpoint Policy
##################################
data "aws_iam_policy_document" "dynamodb_endpoint_policy" {
  statement {
    actions = ["*"]

    principals { 
      type        = "*"
      identifiers = ["*"]
    }

    resources = ["*"]
  }
}