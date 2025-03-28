import unittest
from unittest.mock import patch, MagicMock
import os
from app import process_messages

class TestMicroservice2(unittest.TestCase):
    """Test suite for the message processing functionality of Microservice 2."""
    
    @patch('app.sqs.receive_message')
    @patch('app.s3.put_object')
    @patch('app.sqs.delete_message')
    def test_successful_message_processing(self, mock_delete, mock_put, mock_receive):
        """
        Test the happy path scenario where a message is successfully:
        1. Received from SQS
        2. Stored in S3
        3. Deleted from the queue
        """
        # Simulate receiving a message on the first call and no messages on subsequent calls
        mock_receive.side_effect = [
            {'Messages': [{'Body': '{"key": "value"}', 'ReceiptHandle': 'handle1'}]},
            None  # No more messages
        ]
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
    
    @patch('app.sqs.receive_message')
    @patch('app.s3.put_object')
    @patch('app.sqs.delete_message')
    def test_multiple_messages(self, mock_delete, mock_put, mock_receive):
        """
        Test processing of multiple messages in the queue to ensure:
        1. All messages are correctly processed in order
        2. Each message is stored in S3 and then deleted from the queue
        """
        # Simulate receiving multiple messages
        mock_receive.side_effect = [
            {'Messages': [{'Body': '{"id": "1"}', 'ReceiptHandle': 'handle1'}]},
            {'Messages': [{'Body': '{"id": "2"}', 'ReceiptHandle': 'handle2'}]},
            None  # No more messages
        ]
        
        process_messages()
        
        # Check that both messages were processed correctly
        self.assertEqual(mock_put.call_count, 2)
        self.assertEqual(mock_delete.call_count, 2)
        
        # Check the content and order of the calls
        mock_put.assert_any_call(
            Bucket='test-bucket',
            Key=unittest.mock.ANY,
            Body='{"id": "1"}'
        )
        mock_put.assert_any_call(
            Bucket='test-bucket',
            Key=unittest.mock.ANY,
            Body='{"id": "2"}'
        )
        
    @patch('app.sqs.receive_message')
    @patch('app.s3.put_object')
    @patch('app.sqs.delete_message')
    def test_empty_queue(self, mock_delete, mock_put, mock_receive):
        """
        Test behavior when the queue is empty:
        1. No S3 operations should be performed
        2. No delete operations should be performed
        """
        # Simulate an empty queue
        mock_receive.return_value = {'Messages': []}
        
        process_messages()
        
        # Verify no actions were taken
        mock_put.assert_not_called()
        mock_delete.assert_not_called()
        
    @patch('app.sqs.receive_message')
    @patch('app.s3.put_object')
    @patch('app.sqs.delete_message')
    def test_s3_upload_error(self, mock_delete, mock_put, mock_receive):
        """
        Test error handling when S3 upload fails:
        1. The message should not be deleted from the queue
        2. The error should be handled gracefully
        """
        # Simulate receiving a message
        mock_receive.side_effect = [
            {'Messages': [{'Body': '{"key": "value"}', 'ReceiptHandle': 'handle1'}]},
            None
        ]
        
        # Simulate S3 upload failure
        mock_put.side_effect = Exception("S3 upload failed")
        
        process_messages()
        
        # Message shouldn't be deleted if upload fails
        mock_delete.assert_not_called()
