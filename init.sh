docker build \
   -t local/load-generator-init:2.0.0 .
docker run \
    --env ACTION=${1} \
    --env GCLOUD_TOKEN=${2} \
    --env APIGEE_ORG=${3} \
    --env APIGEE_ENV=${4} \
    --env GPROJECT=${5} \
    --env APPENGINE=${6} \
    --env APIGEE_URL=${7} \
    --env APPENGINE_DOMAIN_NAME=${8} \
    --env GCP_SVC_ACCOUNT_EMAIL=${9} \
    --env RAND=${10} \
local/load-generator-init:2.0.0