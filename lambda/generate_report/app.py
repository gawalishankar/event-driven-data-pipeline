import boto3
import json
from datetime import datetime
import os

s3 = boto3.client('s3')
ses = boto3.client('ses')

raw_bucket = 'event-driven-pipeline-raw-data'
report_bucket = 'event-driven-pipeline-reports'
email = 'gawalisa201@email.com'

def lambda_handler(event, context):
    response = s3.list_objects_v2(Bucket=raw_bucket)
    all_data = []

    for obj in response.get('Contents', []):
        file_data = s3.get_object(Bucket=raw_bucket, Key=obj['Key'])
        content = json.loads(file_data['Body'].read())
        all_data.append(content['data'])

    report = {
        'report_generated': str(datetime.utcnow()),
        'entries_count': len(all_data),
        'entries': all_data
    }

    report_file = f"report-{datetime.utcnow().isoformat()}.json"
    s3.put_object(Bucket=report_bucket, Key=report_file, Body=json.dumps(report))

    ses.send_email(
        Source=email,
        Destination={'ToAddresses': [email]},
        Message={
            'Subject': {'Data': 'Daily Report Generated'},
            'Body': {'Text': {'Data': f"Your report is ready with {len(all_data)} entries."}}
        }
    )

    return {'statusCode': 200, 'body': json.dumps('Report generated and emailed')}
