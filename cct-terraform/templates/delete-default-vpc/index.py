import boto3
import os
import cfnresponse

def handler(event, context):
            try:
              ec2 = boto3.client('ec2', region_name='us-east-1')
              boto3_regions = ec2.describe_regions()
              for region in boto3_regions['Regions']:
                print("Working region: "+region['RegionName'])
                client = boto3.client(
                  'ec2',
                  region_name = region['RegionName']
                )
                response = client.describe_vpcs(
                  Filters=[
                    {
                      'Name': 'isDefault',
                      'Values': [
                        'true',
                      ]
                    },
                  ],
                  DryRun=False
                )
                for vpc in response['Vpcs']:
                  print("  VPC to delete: "+vpc['VpcId'])
                  ## Delete NAT Gateway
                  nat_response = client.describe_nat_gateways(
                    Filters=[
                      {
                        'Name': 'vpc-id',
                        'Values': [
                          vpc['VpcId'],
                        ]
                      },
                    ]
                  )
                  for nat in nat_response['NatGateways']:
                    print("    Deleting NAT Gateway: "+nat['NatGatewayId'])
                    client.delete_nat_gateway(
                      NatGatewayId=nat['NatGatewayId']
                    )
                  ## Delete internet gateway
                  igw_response = client.describe_internet_gateways(
                    Filters=[
                      {
                        'Name': 'attachment.vpc-id',
                        'Values': [
                          vpc['VpcId'],
                        ]
                      },
                    ],
                    DryRun=False
                  )
                  for igw in igw_response['InternetGateways']:
                    print("    Deleting IGW: "+igw['InternetGatewayId'])
                    client.detach_internet_gateway(
                      VpcId=vpc['VpcId'],
                      InternetGatewayId=igw['InternetGatewayId'],
                      DryRun=False,
                    )
                    client.delete_internet_gateway(
                      InternetGatewayId=igw['InternetGatewayId'],
                      DryRun=False
                    )
                  ## Delete Subnets
                  subnet_response = client.describe_subnets(
                    Filters=[
                      {
                        'Name': 'vpc-id',
                        'Values': [
                          vpc['VpcId'],
                        ]
                      },
                    ],
                    DryRun=False
                  )
                  for subnet in subnet_response['Subnets']:
                    print("    Deleting Subnet: "+subnet['SubnetId'])
                    client.delete_subnet(
                      SubnetId=subnet['SubnetId'],
                      DryRun=False
                    )
                  ## Delete VPC
                  delete_response = client.delete_vpc(
                    VpcId=vpc['VpcId'],
                    DryRun=False
                  )
                  print("    VPC Deleted!")
              cfnresponse.send(event, context, cfnresponse.SUCCESS, {})
            except:
              cfnresponse.send(event, context, cfnresponse.FAILED, {"Message": "Error"})