"""Create invalidations for CloudFront cache."""
import os
import boto3
import random
import string
import json
from mklog import WriteLog  # [internal]


def mkrandom():
    """
    Create random string.

    return str
    """
    myrandom = ''.join(
        random.choices(
            string.ascii_uppercase + string.ascii_lowercase + string.digits,
            k=20
        )
    )
    return myrandom


def lambda_handler(event, context) -> dict:
    """
    Create invalidations for CloudFront cache.

    Paths to invalidate come from EventBridge.

    return dict
    """
    try:

        # Initialize logger.
        logger = WriteLog({})

        # Get path to invalidate from EventBridge.
        path = '/' + event['path']

        # Create invalidation details.
        quantity = 1

        # Perform invalidations.
        client = boto3.client('cloudfront')
        response = client.create_invalidation(
            DistributionId=os.environ['CFDIST'],
            InvalidationBatch={
                'Paths': {
                    'Quantity': quantity,
                    'Items': [
                        path
                    ]
                },
                'CallerReference': mkrandom()
            }
        )

        # Create success response.
        status_code = 200
        response_body = {
            'status': response['Invalidation']['Status'],
            'invalidation_id': response['Invalidation']['Id'],
            'paths': (
                response['Invalidation']['InvalidationBatch']
                ['Paths']['Items']
            )
        }

        # Log success message.
        logger.log('status', response['Invalidation']['Status'])
        logger.log('invalidation_id', response['Invalidation']['Id'])
        logger.log(
            'path', (
                response['Invalidation']['InvalidationBatch']
                ['Paths']['Items']
            )
        )

    except Exception as e:

        # Create failure response.
        status_code = 400
        response_body = {
            'status': 'Invalidation failed',
            'request_id': context.aws_request_id,
            'error': str(e)
        }

        # Log failure message.
        logger.log('status', 'Invalidation failed')
        logger.log('error', str(e))

    print(json.dumps(logger.text))
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(response_body)
    }
