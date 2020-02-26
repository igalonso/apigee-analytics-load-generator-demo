USR=$1
PASS=$2
APIGEE_ORG=$3
TOKEN=$(echo "$USR:$PASS\c" | base64)
APIGEE_URL="https://api.enterprise.apigee.com/v1/organizations/"$APIGEE_ORG"/"

env TOKEN=$TOKEN APIGEE_URL="https://api.enterprise.apigee.com/v1/organizations/"$APIGEE_ORG"/" locust --host=https://$APIGEE_ORG-test.apigee.net/v1 --no-web -c 2 -r 1 -f locust-load.py