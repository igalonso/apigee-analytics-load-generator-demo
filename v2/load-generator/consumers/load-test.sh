GCP_TOKEN=$1
APIGEE_ORG=$2
APIGEE_ENV=$3
HOST=$4
echo GCP_TOKEN=$GCP_TOKEN
echo APIGEE_ORG=$APIGEE_ORG
echo APIGEE_ENV=$APIGEE_ENV
echo HOST=$HOST
echo https://$HOST/v1

curl https://$HOST/v1/loyalty/5?apikey=qUo7OxCtC0EEu7hSqJIpvSzPaJBEAlOB9e7v4WI1cIjAcwdm -I -o headers -s
cat headers
env TOKEN=$GCP_TOKEN APIGEE_ORG=$APIGEE_ORG APIGEE_ENV=$APIGEE_ENV locust --host=https://$HOST/v1 --no-web -c 1 -r 1 -f locust-load.py