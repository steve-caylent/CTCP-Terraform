##################################
# Data Sources
##################################
data "aws_ssm_parameter" "sec_sns_topic" {
  name = var.sec_alert_sns_topic
}

##################################
# CloudTrail Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "cloudtrail_action_metric_filter" {
  name           = "CloudtrailActionMetricFilter"
  pattern        = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "cloudtrail-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "cloudtrail_action_cloudwatch_alarm" {
  alarm_name                = "caylent-cloudtrail-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete Cloudtrail"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "cloudtrail-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# Security Group Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "securitygroup_action_metric_filter" {
  name           = "SecurityGroupActionMetricFilter"
  pattern        = "{ ($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "security-group-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "securityGroup_action_cloudwatch_alarm" {
  alarm_name                = "caylent-security-group-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete security groups"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "security-group-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

###################
# NACL Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "nacl_action_metric_filter" {
  name           = "NACLActionMetricFilter"
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "nacl-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "nacl_action_cloudwatch_alarm" {
  alarm_name                = "caylent-nacl-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete nacls"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "nacl-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# IGW Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "igw_action_metric_filter" {
  name           = "IGWActionMetricFilter"
  pattern        =  "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "igw-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "igw_action_cloudwatch_alarm" {
  alarm_name                = "caylent-igw-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete igws"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "igw-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# VPC Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "vpc_action_metric_filter" {
  name           = "VPCActionMetricFilter"
  pattern        =  "{ ($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = ModifyVpcAttribute) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "vpc-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "vpc_action_cloudwatch_alarm" {
  alarm_name                = "caylent-vpc-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete vpc"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "vpc-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# Config Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "config_action_metric_filter" {
  name           = "ConfigActionMetricFilter"
  pattern        =  "{ ($.eventSource = config.amazonaws.com) && (($.eventName = StopConfigurationRecorder)||($.eventName = DeleteDeliveryChannel)||($.eventName = PutDeliveryChannel)||($.eventName = PutConfigurationRecorder)) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "config-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "config_action_cloudwatch_alarm" {
  alarm_name                = "caylent-config-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete config"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "config-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# Route Table Actions
##################################
resource "aws_cloudwatch_log_metric_filter" "route_table_action_metric_filter" {
  name           = "RouteTableActionMetricFilter"
  pattern        =  "{ ($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DeleteRoute) || ($.eventName = DisassociateRouteTable) }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "route-table-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "route_table_action_cloudwatch_alarm" {
  alarm_name                = "caylent-route-table-action-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete route tables"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "route-table-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# Root Usage
##################################
resource "aws_cloudwatch_log_metric_filter" "root_usage_metric_filter" {
  name           = "RootUsageMetricFilter"
  pattern        =   "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "root-account-usage"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_usage_cloudwatch_alarm" {
  alarm_name                = "caylent-root-account-usage-alarm"
  alarm_description         = "Alarms when an API calls are made from the root account"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "root-account-usage"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# Console sign-in failure
##################################
resource "aws_cloudwatch_log_metric_filter" "console_signin_failures__metric_filter" {
  name           = "ConsoleSignInFailuresMetricFilter"
  pattern        =    "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "console-sign-in-failures"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_signin_failures_cloudwatch_alarm" {
  alarm_name                = "caylent-console-sign-in-failures-alarm"
  alarm_description         = "Alarms when console sign-in failures occur"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "console-sign-in-failures"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

###############################
# Organization actions
##################################
resource "aws_cloudwatch_log_metric_filter" "organization_actions_metric_filter" {
  name           = "OrganizationActionsMetricFilter"
  pattern        =    "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "organization-actions"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "organization_actions_cloudwatch_alarm" {
  alarm_name                = "caylent-organization-actions-alarm"
  alarm_description         = "Alarms when an API call is made to create, update, or delete organizations"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "organization-actions"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}

##################################
# Console sign-in without MFA
##################################
resource "aws_cloudwatch_log_metric_filter" "console_signin_without_mfa_metric_filter" {
  name           = "ConsoleSignInWithoutMFAMetricFilter"
  pattern        =    "{ $.eventName = \"ConsoleLogin\" && $.additionalEventData.MFAUsed = \"No\" }"
  log_group_name = var.log_group_name

  metric_transformation {
    name      = "console-sign-in-without-mfa"
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "console_signin_without_mfa_cloudwatch_alarm" {
  alarm_name                = "caylent-console-sign-in-without-mfa-alarm"
  alarm_description         = "Alarms when a user signs in without MFA"
  alarm_actions             = ["${data.aws_ssm_parameter.sec_sns_topic.value}"] 
  metric_name               = "console-sign-in-without-mfa"
  namespace                 = var.metric_namespace
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  treat_missing_data        = "notBreaching"
}