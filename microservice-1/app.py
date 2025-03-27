from flask import Flask, request, jsonify
import boto3
import os
import time
from datetime import datetime
import logging

app = Flask(__name__)

logging.basicConfig(level=logging.INFO)

# AWS SQS and SSM clients
sqs = boto3.client('sqs', region_name=os.getenv('AWS_REGION', 'us-east-2'))
ssm = boto3.client('ssm', region_name=os.getenv('AWS_REGION', 'us-east-2'))

# Environment variables
QUEUE_URL = os.getenv('QUEUE_URL')
TOKEN_PARAM_NAME = os.getenv('TOKEN_PARAM_NAME')

@app.route('/process', methods=['POST'])
def process_request():
    logging.info("Processing request...")
    try:
        # Parse JSON payload
        payload = request.json
        token = payload.get('token')
        data = payload.get('data')

        # Validate token
        stored_token = ssm.get_parameter(Name=TOKEN_PARAM_NAME, WithDecryption=True)['Parameter']['Value']
        if token != stored_token:
            return jsonify({'error': 'Invalid token'}), 401

        # Validate required fields in data
        required_fields = ['email_subject', 'email_sender', 'email_timestream', 'email_content']
        missing_fields = [field for field in required_fields if field not in data]
        if missing_fields:
            return jsonify({'error': f'Missing required fields: {", ".join(missing_fields)}'}), 400

        # Validate email_timestream
        email_timestream = data.get('email_timestream')
        try:
            # Ensure the timestamp is valid and not in the future
            email_timestamp = int(email_timestream)
            if email_timestamp > int(time.time()):
                return jsonify({'error': 'email_timestream cannot be in the future'}), 400
        except (ValueError, TypeError):
            return jsonify({'error': 'Invalid email_timestream format'}), 400

        # Publish to SQS
        sqs.send_message(QueueUrl=QUEUE_URL, MessageBody=str(data))
        return jsonify({'message': 'Message published to SQS'}), 200

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({'status': 'healthy'}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)