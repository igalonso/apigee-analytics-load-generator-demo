GCLOUD_APIGEE_TOKEN=$1
APIGEE_ORG=$2
APIGEE_ENV=$3
GPROJECT_APIGEE=$4
GPROJECT_GCP=$5
APPENGINE=$6
APIGEE_URL=$7
APPENGINE_DOMAIN_NAME=$8
GCP_SVC_ACCOUNT_EMAIL=$9
RAND=${10}

echo TOKEN=$GCLOUD_APIGEE_TOKEN
echo ORG=$APIGEE_ORG
echo ENV=$APIGEE_ENV
echo GPROJECT_APIGEE=$GPROJECT_APIGEE
echo GPROJECT_GCP=$GPROJECT_GCP
echo APPENGINE=$APPENGINE
echo APIGEEURL=$APIGEE_URL
echo APPENGINE_DOMAIN_NAME=$APPENGINE_DOMAIN_NAME
echo GCP_SVC_ACCOUNT_EMAIL=$GCP_SVC_ACCOUNT_EMAIL
echo RAND=$RAND

#sleep 90

gcloud auth activate-service-account \
        $GCP_SVC_ACCOUNT_EMAIL \
        --key-file=../load-generator-key.json --project=$GPROJECT_GCP

#Deploying backend
echo "---->DEPLOYING BACKENDS<-------"
cd backend/services
gcloud config set project $GPROJECT_GCP
gcloud config list
cd catalog
gcloud app deploy app.yaml --project $GPROJECT_GCP --promote --quiet
cd ../checkout
gcloud app deploy app.yaml --project $GPROJECT_GCP --promote --quiet
cd ../loyalty
gcloud app deploy app.yaml --project $GPROJECT_GCP --promote --quiet
cd ../recommendation
gcloud app deploy app.yaml --project $GPROJECT_GCP --promote --quiet
cd ../users
gcloud app deploy app.yaml --project $GPROJECT_GCP --promote --quiet
cd ..
#Set dispatch.yaml
sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" dispatch.yaml
gcloud app deploy dispatch.yaml --project $GPROJECT_GCP --quiet

#Deploy target servers
gcloud config set project $GPROJECT_APIGEE
echo "---->DEPLOYING Target Servers<-------"
cd ../../config/
cp shared-pom.xml.template shared-pom.xml
cp edge.json.template edge.json
sed -i "s/<environment>/$APIGEE_ENV/g" shared-pom.xml
sed -i "s/<environment>/$APIGEE_ENV/g" edge.json
cd targetservers
cp shared-pom.xml.template shared-pom.xml
sed -i "s/<environment>/$APIGEE_ENV/g" shared-pom.xml
cp edge.json.template edge.json
sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" edge.json
sed -i "s/<environment>/$APIGEE_ENV/g" edge.json
#mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dapigee.config.options=create
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN -Dapigee.config.options=create
#Deploying proxies
echo "---->DEPLOYING PROXIES<-------"
cd ../../proxies
cd Load-Generator-Catalog
cp config.json.template config.json
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
cd ../Load-Generator-Checkout
cp config.json.template config.json
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
cd ../Load-Generator-Loyalty
cp config.json.template config.json
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
cd ../Load-Generator-Recommendation
cp config.json.template config.json
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
cd ../Load-Generator-User
cp config.json.template config.json
sed -i "s/<environment>/$APIGEE_ENV/g" config.json
sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN


#Deploy products


echo "---->DEPLOYING PRODUCTS, DEVELOPERS AND APPS<-------"
cd ../../config
sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" edge.json
sed -i "s/<environment>/$APIGEE_ENV/g" edge.json
mvn install -Ptest -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN -Dapigee.config.options=create

#Building docker image for Cloud Run
cd ../consumers

cp Dockerfile_template Dockerfile
sed -i "s/GCP_TOKEN/$GCLOUD_APIGEE_TOKEN/g" Dockerfile
sed -i "s/APIGEE_ORG/$APIGEE_ORG/g" Dockerfile
sed -i "s/APIGEE_ENV/$APIGEE_ENV/g" Dockerfile
sed -i "s/HOST/$APIGEE_URL/g" Dockerfile

gcloud config set project $GPROJECT_GCP

gcloud services enable cloudbuild.googleapis.com compute.googleapis.com storage.googleapis.com storage-api.googleapis.com   
gcloud builds submit --tag gcr.io/$GPROJECT_GCP/load-test


gcloud compute addresses create $(echo "load-locust-asia-east1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-asia-northeast1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-europe-north1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-europe-west1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-us-central1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-us-east1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-us-east4-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-us-west1-ip-"$RAND) --region europe-west2
gcloud compute addresses create $(echo "load-locust-europe-west4-ip-"$RAND) --region europe-west2

# sleep 60

ADDR=$(gcloud compute addresses describe load-locust-asia-east1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-asia-east1-"$RAND) --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b 
ADDR=$(gcloud compute addresses describe load-locust-asia-northeast1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-asia-northeast1-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b
ADDR=$(gcloud compute addresses describe load-locust-europe-north1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-europe-north1-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b
ADDR=$(gcloud compute addresses describe load-locust-europe-west1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-europe-west1-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b 
ADDR=$(gcloud compute addresses describe load-locust-us-central1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-us-central1-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b 
ADDR=$(gcloud compute addresses describe load-locust-us-east1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-us-east1-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b
ADDR=$(gcloud compute addresses describe load-locust-us-east4-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-us-east4-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b
ADDR=$(gcloud compute addresses describe load-locust-us-west1-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-us-west1-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b
ADDR=$(gcloud compute addresses describe load-locust-europe-west4-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
gcloud compute instances create-with-container $(echo "load-locust-europe-west4-"$RAND)  --machine-type=e2-small --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b 