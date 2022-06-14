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
data "aws_ssm_parameter" "private_subnet_ids" {
  name = var.private_subnet_ids
}

##################################
# RDS Subnet Group
##################################
resource "aws_db_subnet_group" "db_subnet_group" {
  count = var.create_db_subnet_group == "true" ? 1 : 0
  name        = "private-subnet-group"
  subnet_ids  = [data.aws_ssm_parameter.private_subnet_ids.value]
  description = "Subnet group with private subnets"
  tags = local.common_tags
}

##################################
# Elasticache Subnet Group
##################################
resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  count = var.create_elasticache_subnet_group == "true" ? 1 : 0
  name       = "elasticache-subnet-group"
  subnet_ids = [data.aws_ssm_parameter.private_subnet_ids.value]
  description = "Subnet group with private subnets"
  tags = local.common_tags
}