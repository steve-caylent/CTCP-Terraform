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
data "aws_ssm_parameter" "vpc_id_endpoint" {
  name = var.vpc_id
}

##################################
# ALB Security Group
##################################
resource "aws_security_group" "alb_security_group" {
  name        = var.alb_group_name
  description = "Application load balancer security group"
  vpc_id      = "${data.aws_ssm_parameter.vpc_id_endpoint.value}"

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

##################################
# Web Security Group
##################################
resource "aws_security_group" "web_security_group" {
  name        = var.web_group_name
  description = "Webserver security group"
  vpc_id      = "${data.aws_ssm_parameter.vpc_id_endpoint.value}"

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}

##################################
# DB Security Group
##################################
resource "aws_security_group" "db_security_group" {
  name        = var.db_group_name
  description = "Database security group"
  vpc_id      = "${data.aws_ssm_parameter.vpc_id_endpoint.value}"

  ingress {
    protocol         = "tcp"
    from_port        = var.db_port
    to_port          = var.db_port
    security_groups  = [aws_security_group.alb_security_group.id]
  }

  egress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = local.common_tags
}
