import boto3
import os
import time
import logging
from flask import Flask, jsonify

logging.basicConfig(level=logging.INFO)

# AWS SQS and S3 clients
sqs = boto3.client('sqs', region_name=os.getenv('AWS_REGION', 'us-east-2'))
s3 = boto3.client('s3', region_name=os.getenv('AWS_REGION', 'us-east-2'))

# Environment variables
QUEUE_URL = os.getenv('QUEUE_URL')
BUCKET_NAME = os.getenv('BUCKET_NAME')
PULL_INTERVAL = int(os.getenv('PULL_INTERVAL', 5))  # Default to 5 seconds if not set

app = Flask(__name__)

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'}), 200

def process_messages():
    while True:
        logging.info("Polling messages...")
        response = sqs.receive_message(QueueUrl=QUEUE_URL, MaxNumberOfMessages=10, WaitTimeSeconds=10)
        messages = response.get('Messages', [])
        for message in messages:
            body = message['Body']
            receipt_handle = message['ReceiptHandle']

            # Upload to S3
            s3.put_object(Bucket=BUCKET_NAME, Key=f"messages/{time.time()}.json", Body=body)

            # Delete message from SQS
            sqs.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=receipt_handle)

        time.sleep(PULL_INTERVAL)

if __name__ == '__main__':
    # Ensure the Flask app runs properly
    from threading import Thread
    Thread(target=process_messages, daemon=True).start()
    app.run(host='0.0.0.0', port=5001)