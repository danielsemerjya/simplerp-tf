import json

def lambda_handler(event, context):
    response = {
        "statusCode": 201,
        "body": json.dumps({
            "message": "Item created successfully",
        })
    }
    
    return response
