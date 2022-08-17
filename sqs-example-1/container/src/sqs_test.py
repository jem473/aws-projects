import os
import subprocess
import boto3
import json
from urllib.parse import unquote_plus

sqs = boto3.resource('sqs')
queue = sqs.queue(os.environ['SQSQueueURL'])

s3 = boto3.resource('s3')
mp3_bucket = s3.Bucket(os.environ['MP3Bucket'])

def main():
    while True:
        messages = queue.receive_messages(
            MaxNumberOfMessages = 10,
            WaitTimeSeconds = 20
        )
        if len(messages) == 0:
            exit()
        for message in messages:
            json_body = json.loads(message.body)
            if 'Records' not in json_body:
                continue
            for record in json_body['Records']:
                s3_data = record['s3']
                object_key = s3_data['object']['key']
                '''We have to unquote HTML values, or some values (such as
                those with spaces, which are replaced with +) will fail.'''
                object_key = unquote_plus(object_key)
                if record['eventName'].startswith('ObjectCreated'):
                    bucket_name = s3_data['bucket']['name']
                    handle_object_created(bucket_name, object_key)
                elif record['eventName'].startswith('ObjectRemoved'):
                    handle_object_removed(object_key)
        queue.delete_messages(
            Entries = [{'Id': f"{count}", 'ReceiptHandle': message.receipt_handle} for count, message in enumerate(messages)]
        )

'''Handles an object created event by downloading the file,
converting it using FFmpeg, and then uploading it to the MP3
bucket.'''
def handle_object_created(origin_bucket_name, object_key):
    origin_bucket = s3.Bucket(origin_bucket_name)
    
    original_filename = object_key.split('/')[-1]
    original_location = f'/tmp/{original_filename}'
    mp3_filename = change_file_extension(original_filename, 'mp3')
    mp3_location = f'/tmp/{mp3_filename}'
    
    origin_bucket.download_file(object_key, original_location)
    conversion_command = [
        'ffmpeg', '-i', original_location, '-ab', '320k',
        '-map_metadata', '0', '-id3v2_version', '3',
        mp3_location
    ]
    subprocess.run(conversion_command)
    if os.path.exists(mp3_location):
        mp3_object_key = '/'.join(object_key.split('/')[:-1] + [mp3_filename])
        mp3_bucket.upload_file(mp3_location, mp3_object_key)

        # Cleanup
        os.remove(original_location)
        os.remove(mp3_location)

'''Handles an object removed event in the origin bucket by deleting the
corresponding MP3 file.'''
def handle_object_removed(object_key):
    mp3_bucket.delete_objects(
        Delete={
            'Objects': [
                {
                    'Key': change_file_extension(object_key, 'mp3')
                }
            ]
        }
    )

'''Change the file extension of a filename. Could do this using
pathlib instead...'''
def change_file_extension(filename, replacement):
    last_dot = filename.rfind('.')
    if last_dot < 0:
        return f'{filename}.{replacement}'
    return f'{filename[:last_dot]}.{replacement}'

if __name__ == '__main__':
    main()