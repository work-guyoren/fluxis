import unittest
from unittest.mock import patch, MagicMock
import os
from app import app

class TestMicroservice1(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    @patch('app.ssm.get_parameter')
    def test_token_validation(self, mock_ssm):
        mock_ssm.return_value = {'Parameter': {'Value': os.getenv('TOKEN_PARAM_NAME', 'valid-token')}}
        response = self.client.post('/', json={
            'token': 'invalid-token',
            'data': {}
        })
        self.assertEqual(response.status_code, 401)

    def test_missing_fields(self):
        response = self.client.post('/', json={
            'token': 'valid-token',
            'data': {'email_subject': 'Test'}
        })
        self.assertEqual(response.status_code, 400)
        self.assertIn('Missing required fields', response.json['error'])

    @patch('app.sqs.send_message')
    @patch('app.ssm.get_parameter')
    def test_sqs_message_publishing(self, mock_ssm, mock_sqs):
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
