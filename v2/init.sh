echo ACTION=$1
echo GCLOUD_APIGEE_TOKEN=$2
echo APIGEE_ORG=$3
echo APIGEE_ENV=$4
echo GPROJECT_APIGEE=$5 
echo GPROJECT_GCP=$6
echo APPENGINE=$7 
echo APIGEE_URL=$8 
echo APPENGINE_DOMAIN_NAME=$9 
echo GCP_SVC_ACCOUNT_EMAIL=${10} 
echo RAND=${11} 
docker build \
   -t local/load-generator-init:2.0.0 .
docker run \
    --env ACTION=${1} \
    --env GCLOUD_APIGEE_TOKEN=${2} \
    --env APIGEE_ORG=${3} \
    --env APIGEE_ENV=${4} \
    --env GPROJECT_APIGEE=${5} \
    --env GPROJECT_GCP=${6} \
    --env APPENGINE=${7} \
    --env APIGEE_URL=${8} \
    --env APPENGINE_DOMAIN_NAME=${9} \
    --env GCP_SVC_ACCOUNT_EMAIL=${10} \
    --env RAND=${11} \
local/load-generator-init:2.0.0