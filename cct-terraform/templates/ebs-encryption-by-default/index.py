import boto3
import os
# import cfnresponse

region_list = os.environ["Region_List"]

def handler(event, context):
    success = 0
    param_input_list=region_list
    print("Regions: "+param_input_list)
    for region in param_input_list.split(","):
        print("Trying "+region+"...")
        try:
            ec2 = boto3.client("ec2", region_name=region)
            res = ec2.enable_ebs_encryption_by_default()
            res.update(ec2.modify_ebs_default_kms_key_id(KmsKeyId="alias/aws/ebs"))
            res.pop("ResponseMetadata", None)
            print("Success")
            print(res)
            success = success + 1  
        except Exception as e:
            print("Error:", repr(e))
    print("Success: "+str(success))
    # if success == len(param_input_list.split(",")):
    #     cfnresponse.send(event, context, cfnresponse.SUCCESS, res)
    # else:
    #     cfnresponse.send(event, context, cfnresponse.FAILED, {"Message": "Error"})