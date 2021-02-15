GCP_TOKEN=$1
APIGEE_ORG=$2
APIGEE_ENV=$3
HOST=$4
echo $GCP_TOKEN
echo $APIGEE_ORG
echo $APIGEE_ENV
echo $HOST
echo https://$HOST/v1
env TOKEN=$GCP_TOKEN APIGEE_ORG=$APIGEE_ORG APIGEE_ENV=$APIGEE_ENV locust --host=https://$HOST/v1 --no-web -c 1 -r 1 -f locust-load.py