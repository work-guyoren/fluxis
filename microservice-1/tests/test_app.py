import unittest
from unittest.mock import patch, MagicMock
import os
from app import app

class TestMicroservice1(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    @patch('app.ssm.get_parameter')
    def test_token_validation(self, mock_ssm):
        """
        Test that the API validates authentication tokens correctly.
        It should return 401 Unauthorized when an invalid token is provided.
        """
        mock_ssm.return_value = {'Parameter': {'Value': os.getenv('TOKEN_PARAM_NAME', 'valid-token')}}
        response = self.client.post('/', json={
            'token': 'invalid-token',
            'data': {}
        })
        self.assertEqual(response.status_code, 401)

    def test_missing_fields(self):
        """
        Test that the API properly validates required fields in the request payload.
        It should return 400 Bad Request when required fields are missing.
        """
        response = self.client.post('/', json={
            'token': 'valid-token',
            'data': {'email_subject': 'Test'}
        })
        self.assertEqual(response.status_code, 400)
        self.assertIn('Missing required fields', response.json['error'])

    @patch('app.sqs.send_message')
    @patch('app.ssm.get_parameter')
    def test_sqs_message_publishing(self, mock_ssm, mock_sqs):
        """
        Test that the API successfully publishes messages to SQS when all
        required data is provided and the token is valid. It should return
        a 200 OK response on success.
        """
        mock_ssm.return_value = {'Parameter': {'Value': 'valid-token'}}
        mock_sqs.return_value = {}
        response = self.client.post('/', json={
            'token': 'valid-token',
            'data': {
                'email_subject': 'Test',
                'email_sender': 'test@example.com',
                'email_timestream': '1234567890',
                'email_content': 'Hello World'
            }
        })
        self.assertEqual(response.status_code, 200)
        mock_sqs.assert_called_once()
