import boto3
from botocore.exceptions import ClientError
import os
import cfnresponse

##########################################
# Environment Variables
##########################################
region = os.environ['Region']
enable_organization_service = os.environ['EnableOrganizationalService']
service_admin_account = os.environ['ServiceAdministratorAccount']

def handler(event, context):
try:
    client = boto3.client('organizations', region_name=region)
    response = []
    if enable_organization_service == 'true':
        res = client.enable_aws_service_access(
            ServicePrincipal='guardduty.amazonaws.com'
        )
        ec2_region = boto3.client('ec2', region_name='us-east-1')
        response_region = ec2_region.describe_regions()
        for region in response_region['Regions']:
            print("Trying region: "+region['RegionName'])
            gdClient = boto3.client('guardduty', region_name=region['RegionName'])
            try:
            response = gdClient.enable_organization_admin_account(
                AdminAccountId=service_admin_account
            )
            except ClientError as e:
            if e.response['Error']['Code'] == 'BadRequestException':
                print("Error handled")
                print(e)
        res.pop("ResponseMetadata", None)
        response.append(res)
    cfnresponse.send(event, context, cfnresponse.SUCCESS, res)
except Exception as e:
    print("Error:", repr(e))
    cfnresponse.send(event, context, cfnresponse.FAILED, {"Message": "Error"})