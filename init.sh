APIGEE_USER=$1
APIGEE_PASS=$2
APIGEE_ORG=$3
APIGEE_ENV=$4
GPROJECT=$5
APPENGINE=$6
TOKEN=$(echo "$APIGEE_USER:$APIGEE_PASS\c" | base64)
APIGEE_URL=$7
APPENGINE_DOMAIN_NAME=$8
GCP_SVC_ACCOUNT_EMAIL=$9
RAND=$10

docker build \
   -t local/load-generator-init:1.0.0 .
docker run \
    --env APIGEE_USER=$APIGEE_USER \
    --env APIGEE_PASS=$APIGEE_PASS \
    --env APIGEE_ORG=$APIGEE_ORG \
    --env APIGEE_ENV=$APIGEE_ENV \
    --env GPROJECT=$GPROJECT \
    --env APPENGINE=$APPENGINE \
    --env APIGEE_URL=$APIGEE_URL \
    --env APPENGINE_DOMAIN_NAME=$APPENGINE_DOMAIN_NAME \
    --env GCP_SVC_ACCOUNT_EMAIL=$GCP_SVC_ACCOUNT_EMAIL \
    --env RAND=$RAND \
local/load-generator-init:1.0.0