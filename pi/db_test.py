import boto3
import json

client = boto3.client('lambda', region_name='us-east-1')

def writeToDB(table, id):
    client.invoke(
            FunctionName = 'WriteToTable',
            Payload = json.dumps({'tableName': table, 'id': id}))

if __name__ == '__main__':
    writeToDB('room_check_in', 2)
