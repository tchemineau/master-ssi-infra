import json
import os

from flask import escape, jsonify
from google.cloud import storage
import functions_framework


@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """
    request_json = request.get_json(silent=True)
    request_args = request.args

    if request_json and "name" in request_json:
        name = request_json["name"]
    elif request_args and "name" in request_args:
        name = request_args["name"]
    else:
        name = "World"

    bucket_name = os.getenv("BUCKET_NAME")
    bucket_key = "data.json"

    response = jsonify(
        content="Hello {}!".format(escape(name)),
        name=escape(name),
        url=f"https://storage.cloud.google.com/{bucket_name}/{bucket_key}"
    )

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    blob = bucket.blob(bucket_key)
    content = json.loads(blob.download_as_string())

    if name not in content:
        content[name] = 0
    content[name] += 1

    blob.upload_from_string(json.dumps(content))

    return response
