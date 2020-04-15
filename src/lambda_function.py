import json
import os

import boto3


def send_notification(body):
    sns = boto3.client('sns')
    response = sns.publish(TopicArn=os.environ['email_topic'], Message=body)
    print (response)


def is_authorized(config, source_ip, entity_name):
    is_source_authorized = source_ip in config['authorized_sources']
    is_entity_authorized = entity_name in config['authorized_entities']
    return is_source_authorized and is_entity_authorized


def is_monitored(config, key):
    for keyword in config['sensitive_filename_keywords']:
        if keyword in key:
            return True
    return False


def get_entity(user_identity):
    if user_identity['type'] == 'IAMUser':
        entity_name = user_identity['userName']
        entity_type = 'User'
    else:
        entity_name = user_identity['sessionContext']['sessionIssuer']['userName']
        entity_type = 'Role'
    return entity_type, entity_name


def lambda_handler(event, context):
    with open('config.json', 'r') as fd:
        config = json.load(fd)
    data = event['detail']
    request_parameters = data['requestParameters']
    user_identity = data['userIdentity']
    source_ip = data['sourceIPAddress']
    access_key_id = user_identity['accessKeyId']
    entity_type, entity_name = get_entity(user_identity)
    bucket_name = request_parameters['bucketName']
    key = request_parameters['key']
    if not is_authorized(config, source_ip, entity_name) and is_monitored(config, key):
        print('[x] Unauthorized access detected!')
        send_notification(
            'File {} from bucket {} has been accessed by {} {} from the ip address {} using the Access Key {}'.format(
                key, bucket_name, entity_type, entity_name, source_ip, access_key_id))
    return {
        'statusCode': 200
    }
