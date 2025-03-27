import boto3
import os
import time

# AWS SQS and S3 clients
sqs = boto3.client('sqs', region_name='us-east-1')
s3 = boto3.client('s3', region_name='us-east-1')

# Environment variables
QUEUE_URL = os.getenv('QUEUE_URL')
BUCKET_NAME = os.getenv('BUCKET_NAME')

def process_messages():
    while True:
        response = sqs.receive_message(QueueUrl=QUEUE_URL, MaxNumberOfMessages=10, WaitTimeSeconds=10)
        messages = response.get('Messages', [])

        for message in messages:
            body = message['Body']
            receipt_handle = message['ReceiptHandle']

            # Upload to S3
            s3.put_object(Bucket=BUCKET_NAME, Key=f"messages/{time.time()}.json", Body=body)

            # Delete message from SQS
            sqs.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=receipt_handle)

        time.sleep(5)

if __name__ == '__main__':
    process_messages()