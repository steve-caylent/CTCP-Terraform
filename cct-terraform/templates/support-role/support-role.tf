locals {
  common_tags = {
    Purpose = "caylent-accelerator"
    CreatedBy = "Caylent"
    ManagedBy = "control-tower-pipeline"
  }
}


##################################
# IAM Role for Support Role
#   Assume Role Policy
#   Managed Policy
##################################
resource "aws_iam_role" "aws_support_role" {
  name                = "aws-support-role"
  assume_role_policy  = data.aws_iam_policy_document.user_assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AWSSupportAccess"]
  tags                = local.common_tags
}


##################################
# IAM Policies
#   Assume Roles - User
##################################
data "aws_iam_policy_document" "user_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.aws_support_user.arn]
    }
  }
}

##################################
# IAM User
##################################
resource "aws_iam_user" "aws_support_user" {
  name = "aws-support-user"
  path = "/"
  tags = local.common_tags
  }

##################################
# IAM Group
##################################
resource "aws_iam_group" "aws_support_group" {
  name = "aws-support-group"
  path = "/"
  }

##################################
# IAM Group Membership
##################################
resource "aws_iam_group_membership" "aws_support_group_membership" {
  name = "aws-support-group-membership"

  users = [
    aws_iam_user.aws_support_user.name
  ]

  group = aws_iam_group.aws_support_group.name
}

