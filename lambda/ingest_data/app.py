import json
import boto3
import uuid
import datetime

s3 = boto3.client('s3')
bucket_name = 'event-driven-pipeline-raw-data'

def lambda_handler(event, context):
    data = {
        'timestamp': str(datetime.datetime.utcnow()),
        'data': event.get("body", "No data")
    }

    file_name = f"{uuid.uuid4()}.json"
    s3.put_object(Bucket=bucket_name, Key=file_name, Body=json.dumps(data))
    
    return {
        'statusCode': 200,
        'body': json.dumps('Data stored successfully!')
    }
