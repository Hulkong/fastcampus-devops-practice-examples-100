import boto3
import os
import json
from datetime import datetime

def handler(event, context):
    rds_client = boto3.client('rds')
    rds_instance_id = os.getenv('RDS_INSTANCE_ID')
    response = rds_client.stop_db_instance(DBInstanceIdentifier=rds_instance_id)
    
    # Custom JSON encoder to handle datetime objects
    def json_serializer(obj):
        if isinstance(obj, datetime):
            return obj.isoformat()
        raise TypeError("Type not serializable")
    
    return {
        "statusCode": 200,
        "body": json.dumps(response, default=json_serializer)
    }
