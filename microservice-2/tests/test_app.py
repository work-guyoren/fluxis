import unittest
from unittest.mock import patch, MagicMock
import os
from app import process_messages

class TestMicroservice2(unittest.TestCase):
    @patch('app.sqs.receive_message')
    @patch('app.s3.put_object')
    @patch('app.sqs.delete_message')
    def test_message_processing(self, mock_delete, mock_put, mock_receive):
        mock_receive.return_value = {
            'Messages': [
                {'Body': '{"key": "value"}', 'ReceiptHandle': 'handle1'}
            ]
        }
        mock_put.return_value = {}
        mock_delete.return_value = {}

        process_messages()

        mock_put.assert_called_once_with(
            Bucket='test-bucket',
            Key=unittest.mock.ANY,  # Allow dynamic timestamp in the key
            Body='{"key": "value"}'
        )
        mock_delete.assert_called_once_with(
            QueueUrl=os.getenv('QUEUE_URL', 'test-queue-url'),  # Use environment variable
            ReceiptHandle='handle1'
        )
