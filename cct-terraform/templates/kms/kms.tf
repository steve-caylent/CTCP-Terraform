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
data "aws_caller_identity" "current" {}

##################################
# KMS - Service Key
##################################
resource "aws_kms_key" "service_kms_key" {
  count = var.create_kms_cmks == "true" && var.service_kms_cmks == "true" ? 1 : 0
  description           = "KMS Service Key"
  enable_key_rotation   = var.service_key_rotation
  multi_region          = var.service_multiregion_key
  policy                = data.aws_iam_policy_document.key_policy_service.json
  tags                  = local.common_tags
}

##################################
# KMS Alias - Service Key
##################################
resource "aws_kms_alias" "service_kms_key" {
  count = var.create_kms_cmks == "true" && var.service_kms_cmks == "true" ? 1 : 0
  name          = "alias/${var.service_principal}" 
  target_key_id = aws_kms_key.service_kms_key.key_id
}

#######################################
# IAM Policy Document for KMS - Service
#######################################

data "aws_iam_policy_document" "key_policy_service" {
  statement {
    sid = "Allow Administration of the key"
    actions   = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]    
    }
  }
#   # Need to add a user of the key
#   statement {
#     sid = "Allow service key access"
#     actions   = [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#       ]
#     resources = ["*"]

#     principals {
#       type        = "Service"
#       identifiers = ["${var.service_principal}.amazonaws.com"]    
#     }
#   }
}

##################################
# KMS - Team Key
##################################
resource "aws_kms_key" "team_kms_key" {
  count = var.create_kms_cmks == "true" && var.team_kms_cmks == "true" ? 1 : 0
  description           = "KMS Team Key"
  enable_key_rotation   = var.team_key_rotation
  multi_region          = var.team_multiregion_key
  policy                = data.aws_iam_policy_document.key_policy_team.json
  tags                  = local.common_tags
}

##################################
# KMS Alias - Team Key
##################################
resource "aws_kms_alias" "team_kms_key" {
  count = var.create_kms_cmks == "true" && var.team_kms_cmks == "true" ? 1 : 0
  name          = "alias/${var.team_principal}" 
  target_key_id = aws_kms_key.team_kms_key.key_id
}

#######################################
# IAM Policy Document for KMS - Team
#######################################

data "aws_iam_policy_document" "key_policy_team" {
  statement {
    sid = "Allow Administration of the key"
    actions   = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]    
    }
  }
#   # Need to add a user of the key
#   statement {
#     sid = "Allow team key access"
#     actions   = [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#       ]
#     resources = ["*"]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.team_principal}"]  
#     }
#   }
}

##################################
# KMS - Application Key
##################################
resource "aws_kms_key" "application_kms_key" {
  count = var.create_kms_cmks == "true" && var.application_kms_cmks == "true" ? 1 : 0
  description           = "KMS Application Key"
  enable_key_rotation   = var.application_key_rotation
  multi_region          = var.application_multiregion_key
  policy                = data.aws_iam_policy_document.key_policy_application.json
  tags                  = local.common_tags
}

##################################
# KMS Alias - Application Key
##################################
resource "aws_kms_alias" "team_kms_key" {
  count = var.create_kms_cmks == "true" && var.application_kms_cmks == "true" ? 1 : 0
  name          = "alias/${var.application_principal}" 
  target_key_id = aws_kms_key.application_kms_key.key_id
}

###########################################
# IAM Policy Document for KMS - Application
###########################################

data "aws_iam_policy_document" "key_policy_application" {
  statement {
    sid = "Allow Administration of the key"
    actions   = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]    
    }
  }
#   # Need to add a user of the key
#   statement {
#     sid = "Allow team key access"
#     actions   = [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#       ]
#     resources = ["*"]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.application_principal}"]  
#     }
#   }
}

##################################
# KMS - Compliance Key
##################################
resource "aws_kms_key" "application_kms_key" {
  count = var.create_kms_cmks == "true" && var.compliance_kms_cmks == "true" ? 1 : 0
  description           = "KMS Compliance Key"
  enable_key_rotation   = var.compliance_key_rotation
  multi_region          = var.compliance_multiregion_key
  policy                = data.aws_iam_policy_document.key_policy_compliance.json
  tags                  = local.common_tags
}

##################################
# KMS Alias - Compliance Key
##################################
resource "aws_kms_alias" "compliance_kms_key" {
  count = var.create_kms_cmks == "true" && var.compliance_kms_cmks == "true" ? 1 : 0
  name          = "alias/${var.compliance_principal}" 
  target_key_id = aws_kms_key.compliance_kms_key.key_id
}

###########################################
# IAM Policy Document for KMS - Compliance
###########################################

data "aws_iam_policy_document" "key_policy_compliance" {
  statement {
    sid = "Allow Administration of the key"
    actions   = [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]    
    }
  }
#   # Need to add a user of the key
#   statement {
#     sid = "Allow team key access"
#     actions   = [
#         "kms:Encrypt",
#         "kms:Decrypt",
#         "kms:ReEncrypt*",
#         "kms:GenerateDataKey*",
#         "kms:DescribeKey"
#       ]
#     resources = ["*"]

#     principals {
#       type        = "AWS"
#       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.compliance_principal}"]  
#     }
#   }
}