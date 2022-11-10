import os
import json
import logging
import botocore
import boto3


logLevel = os.getenv("LOG_LEVEL", "ERROR").upper()
log   = logging.getLogger()
log.setLevel(logLevel)


def lambda_handler(event, context):
    log.debug(event)
    messages = event['Records']
    log.info(f"Found {len(messages)} messages")

    for message in messages:
        log.debug(f"message = {message}")
        bucketName = message['s3']['bucket']['name']
        log.info(f"Event Name = {message['eventName']} on bucket {bucketName}")

        