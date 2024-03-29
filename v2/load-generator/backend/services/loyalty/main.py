
import random

from loyalty import *
import time

from flask import Flask
from flask import abort, jsonify
from flask import request
from opencensus.ext.flask.flask_middleware import FlaskMiddleware
from opencensus.ext.stackdriver.trace_exporter import StackdriverExporter
from opencensus.trace import execution_context
from opencensus.trace.propagation import google_cloud_format
from opencensus.trace.samplers import AlwaysOnSampler


# If `entrypoint` is not defined in app.yaml, App Engine will look for an app
# called `app` in `main.py`.
app = Flask(__name__)
@app.errorhandler(404)
def resource_not_found(e):
    return jsonify(error=str(e)), 404
#Loyalty service
@app.route('/loyalty',methods=['GET', 'POST'])
def loyalty(): 
    return {}

@app.route('/loyalty/<int:id>')
def loyaltyMember(id):
    """Return a friendly HTTP greeting."""
    obj=getTotalLoyaltyPoints(id)
    if obj == False:
        abort(404, description="Resource not found")
    else:
        return obj


if __name__ == '__main__':
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    app.run(host='127.0.0.1', port=8080, debug=True)
# [END gae_python37_app]
