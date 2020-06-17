#!/bin/bash
# sh initial.sh <APIGEE_USER> <APIGEE_PASS> <APIGEE_ORG> <APIGEE_ENV> <GPROJECT> <APPENGINE> <APIGEE_URL> <APPENGINE_DOMAIN_NAME> <UUID>

APIGEE_USER=$1
APIGEE_PASS=$2
APIGEE_ORG=$3
APIGEE_ENV=$4
GPROJECT=$5
APPENGINE=$6
TOKEN=$(printf "$APIGEE_USER:$APIGEE_PASS" | base64)
#TOKEN=$(echo "$APIGEE_USER:$APIGEE_PASS\c" | base64)
APIGEE_URL=$7
APPENGINE_DOMAIN_NAME=$8
RAND=$9

#Deploying backend
echo "---->DEPLOYING BACKENDS<-------"
cd backend/services
gcloud config set project $GPROJECT

# Create the App Engine Application for the project
# gcloud app create

cd default
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet
cd ../catalog
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet
cd ../checkout
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet
cd ../loyalty
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet
cd ../recommendation
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet
cd ../users
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet
cd ..
#Set dispatch.yaml
sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" dispatch.yaml
gcloud app deploy dispatch.yaml --project $GPROJECT --quiet

#Deploy target servers
echo "---->DEPLOYING Target Servers<-------"
cd ../../config/targetservers
sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" targetservers.json
sed -i "s/<environment>/$APIGEE_ENV/g" targetservers.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dapigee.config.options=create

#Deploying proxies
echo "---->DEPLOYING PROXIES<-------"
cd ../../proxies
cd Load-Generator-Catalog
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT/g" config.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-Checkout
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT/g" config.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-Loyalty
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT/g" config.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-Recommendation
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT/g" config.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-User
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT/g" config.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV


#Deploy products
echo "---->DEPLOYING PRODUCTS, DEVELOPERS AND APPS<-------"
cd ../../config
sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" edge.json
sed -i "s/<environment>/$APIGEE_ENV/g" edge.json
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dapigee.config.options=create

#Building docker image for Cloud Run
cd ../consumers
cp Dockerfile_template Dockerfile
sed -i "s/APIGEE_USER/$APIGEE_USER/g" Dockerfile
sed -i "s/APIGEE_ORG/$APIGEE_ORG/g" Dockerfile
sed -i "s/APIGEE_PASS/$APIGEE_PASS/g" Dockerfile

gcloud builds submit --tag gcr.io/$GPROJECT/load-test

gcloud compute addresses create $(echo "load-locust-asia-east1-ip-"$RAND) --region asia-east1 
gcloud compute addresses create $(echo "load-locust-asia-northeast1-ip-"$RAND) --region asia-northeast1
gcloud compute addresses create $(echo "load-locust-europe-north1-ip-"$RAND) --region europe-north1
gcloud compute addresses create $(echo "load-locust-europe-west1-ip-"$RAND) --region europe-west1
gcloud compute addresses create $(echo "load-locust-us-central1-ip-"$RAND) --region us-central1
gcloud compute addresses create $(echo "load-locust-us-east1-ip-"$RAND) --region us-east1
gcloud compute addresses create $(echo "load-locust-us-east4-ip-"$RAND) --region us-east4
gcloud compute addresses create $(echo "load-locust-us-west1-ip-"$RAND) --region us-west1
gcloud compute addresses create $(echo "load-locust-europe-west4-ip-"$RAND) --region europe-west4

sleep 60
ADDR=$(gcloud compute addresses describe load-locust-asia-east1-ip-$(echo $RAND) --region asia-east1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
# Removed jq as this requires installation, working with GREP
# ADDR=$(gcloud compute addresses describe load-locust-asia-east1-ip-$(echo $RAND) --region asia-east1 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-asia-east1-"$RAND) --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone asia-east1-b 
ADDR=$(gcloud compute addresses describe load-locust-asia-northeast1-ip-$(echo $RAND) --region asia-northeast1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-asia-northeast1-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone asia-northeast1-b
ADDR=$(gcloud compute addresses describe load-locust-europe-north1-ip-$(echo $RAND) --region europe-north1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-europe-north1-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone europe-north1-b
ADDR=$(gcloud compute addresses describe load-locust-europe-west1-ip-$(echo $RAND) --region europe-west1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-europe-west1-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone europe-west1-b 
ADDR=$(gcloud compute addresses describe load-locust-us-central1-ip-$(echo $RAND) --region us-central1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-us-central1-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-central1-b 
ADDR=$(gcloud compute addresses describe load-locust-us-east1-ip-$(echo $RAND) --region us-east1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-us-east1-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-east1-b
ADDR=$(gcloud compute addresses describe load-locust-us-east4-ip-$(echo $RAND) --region us-east4 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-us-east4-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-east4-b
ADDR=$(gcloud compute addresses describe load-locust-us-west1-ip-$(echo $RAND) --region us-west1 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-us-west1-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-west1-b
ADDR=$(gcloud compute addresses describe load-locust-europe-west4-ip-$(echo $RAND) --region europe-west4 --format json | grep -oP '"address": "\K\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b')
gcloud compute instances create-with-container $(echo "load-locust-europe-west4-"$RAND)  --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone europe-west4-b 