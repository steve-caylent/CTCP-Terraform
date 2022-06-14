##########################################
# Data Sources
##########################################
data "aws_ssoadmin_instances" "adminsso_arn" {}

##########################################
# SSO Permission Set
##########################################
resource "aws_ssoadmin_permission_set" "sso_developer" {
  name             = join("", [var.role_prefix, "DeveloperAccess"])
  description      = "Developer SSO Permission Set"
  instance_arn     = tolist(data.aws_ssoadmin_instances.adminsso_arn.arns)[0]
  session_duration = var.session_duration
}

##########################################
# IAM Policy Document
##########################################
data "aws_iam_policy_document" "sso_permissions" {
  statement {
    actions = ["ec2:*"]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    actions = ["lambda:*"]
    effect = "Allow"
    resources = ["*"]
  }
  statement {
    actions = ["s3:*"]
    effect = "Allow"
    resources = ["*"]
  }  
  statement {
    actions = ["dynamodb:*"]
    effect = "Allow"
    resources = ["*"]
  }  
  statement {
    actions = ["rds:*"]
    effect = "Allow"
    resources = ["*"]
  }  
  statement {
    actions = ["cloudwatch:*"]
    effect = "Allow"
    resources = ["*"]
  }  
  statement {
    actions = ["cloudformation:*"]
    effect = "Allow"
    resources = ["*"]
  }  
  statement {
    actions = ["ec2:Delete*"]
    effect = "Deny"
    resources = ["*"]
  }  
  statement {
    actions = ["lambda:Delete*"]
    effect = "Deny"
    resources = ["*"]
  } 
  statement {
    actions = ["s3:Delete*"]
    effect = "Deny"
    resources = ["*"]
  }   
  statement {
    actions = ["dynamodb:Delete*"]
    effect = "Deny"
    resources = ["*"]
  } 
  statement {
    actions = ["rds:Delete*"]
    effect = "Deny"
    resources = ["*"]
  }    
  statement {
    actions = ["cloudwatch:Delete*"]
    effect = "Deny"
    resources = ["*"]
  }  
  statement {
    actions = ["ec2:AcceptVpcPeeringConnection*"]
    effect = "Deny"
    resources = ["*"]
  }  
  statement {
    actions = [
      "ec2:AcceptVpcEndpointConnections",
      "ec2:AllocateAddress",
      "ec2:AssignIpv6Addresses",
      "ec2:AssignPrivateIpAddresses",
      "ec2:AssociateAddress",
      "ec2:AssociateDhcpOptions",
      "ec2:AssociateRouteTable",
      "ec2:AssociateSubnetCidrBlock",
      "ec2:AssociateVpcCidrBlock",
      "ec2:AttachClassicLinkVpc",
      "ec2:AttachInternetGateway",
      "ec2:AttachNetworkInterface",
      "ec2:AttachVpnGateway",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateCarrierGateway",
      "ec2:CreateCustomerGateway",
      "ec2:CreateDefaultSubnet",
      "ec2:CreateDefaultVpc",
      "ec2:CreateDhcpOptions",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateFlowLogs",
      "ec2:CreateInternetGateway",
      "ec2:CreateLocalGatewayRouteTableVpcAssociation",
      "ec2:CreateNatGateway",
      "ec2:CreateNetworkAcl",
      "ec2:CreateNetworkAclEntry",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:CreateVpcEndpoint",
      "ec2:CreateVpcEndpointConnectionNotification",
      "ec2:CreateVpcEndpointServiceConfiguration",
      "ec2:CreateVpcPeeringConnection",
      "ec2:CreateVpnConnection",
      "ec2:CreateVpnConnectionRoute",
      "ec2:CreateVpnGateway",
      "ec2:DeleteCarrierGateway",
      "ec2:DeleteCustomerGateway",
      "ec2:DeleteDhcpOptions",
      "ec2:DeleteEgressOnlyInternetGateway",
      "ec2:DeleteFlowLogs",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteLocalGatewayRouteTableVpcAssociation",
      "ec2:DeleteNatGateway",
      "ec2:DeleteNetworkAcl",
      "ec2:DeleteNetworkAclEntry",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSubnet",
      "ec2:DeleteTags",
      "ec2:DeleteVpc",
      "ec2:DeleteVpcEndpoints",
      "ec2:DeleteVpcEndpointConnectionNotifications",
      "ec2:DeleteVpcEndpointServiceConfigurations",
      "ec2:DeleteVpcPeeringConnection",
      "ec2:DeleteVpnConnection",
      "ec2:DeleteVpnConnectionRoute",
      "ec2:DeleteVpnGateway",
      "ec2:DetachClassicLinkVpc",
      "ec2:DetachInternetGateway",
      "ec2:DetachNetworkInterface",
      "ec2:DetachVpnGateway",
      "ec2:DisableVgwRoutePropagation",
      "ec2:DisableVpcClassicLink",
      "ec2:DisableVpcClassicLinkDnsSupport",
      "ec2:DisassociateAddress",
      "ec2:DisassociateRouteTable",
      "ec2:DisassociateSubnetCidrBlock",
      "ec2:DisassociateVpcCidrBlock",
      "ec2:EnableVgwRoutePropagation",
      "ec2:EnableVpcClassicLink",
      "ec2:EnableVpcClassicLinkDnsSupport",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:ModifySecurityGroupRules",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:ModifyVpcEndpoint",
      "ec2:ModifyVpcEndpointConnectionNotification",
      "ec2:ModifyVpcEndpointServiceConfiguration",
      "ec2:ModifyVpcEndpointServicePermissions",
      "ec2:ModifyVpcPeeringConnectionOptions",
      "ec2:ModifyVpcTenancy",
      "ec2:MoveAddressToVpc",
      "ec2:RejectVpcEndpointConnections",
      "ec2:RejectVpcPeeringConnection",
      "ec2:ReleaseAddress",
      "ec2:ReplaceNetworkAclAssociation",
      "ec2:ReplaceNetworkAclEntry",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation",
      "ec2:ResetNetworkInterfaceAttribute",
      "ec2:RestoreAddressToClassic",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UnassignIpv6Addresses",
      "ec2:UnassignPrivateIpAddresses",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
      ]
    effect = "Deny"
    resources = ["*"]
  } 
}

##########################################
# SSO Permission Set - Inline Policy
##########################################
resource "aws_ssoadmin_permission_set_inline_policy" "sso_inline" {
  inline_policy      = data.aws_iam_policy_document.sso_permissions.json
  instance_arn       = aws_ssoadmin_permission_set.sso_developer.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.sso_developer.arn
}

##########################################
# Output - SSO Arn
##########################################
output "sso_arn" {
  value = aws_ssoadmin_permission_set.sso_developer.arn
}