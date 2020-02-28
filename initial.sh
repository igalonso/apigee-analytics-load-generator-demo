# sh initial.sh <APIGEE_USER> <APIGEE_PASS> <APIGEE_ORG> <APIGEE_ENV> <GPROJECT> <APPENGINE> <APIGEE_URL>

APIGEE_USER=$1
APIGEE_PASS=$2
APIGEE_ORG=$3
APIGEE_ENV=$4
GPROJECT=$5
APPENGINE=$6
TOKEN=$(echo "$APIGEE_USER:$APIGEE_PASS\c" | base64)
APIGEE_URL=$7

#Deploying backend
echo "---->DEPLOYING BACKENDS<-------"
cd backend
gcloud config set project $GPROJECT
gcloud app deploy app.yaml --project $APPENGINE --promote --quiet

#Deploying proxies
echo "---->DEPLOYING PROXIES<-------"
cd ../proxies
cd Load-Generator-Catalog
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-Checkout
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-Loyalty
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-Recommendation
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV
cd ../Load-Generator-User
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV


#Deploy products


echo "---->DEPLOYING PRODUCTS, DEVELOPERS AND APPS<-------"
cd ../../config
mvn install -Ptest -Dusername=$APIGEE_USER -Dpassword=$APIGEE_PASS -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dapigee.config.options=create

#Building docker image for Cloud Run
cd ../consumers
cp Dockerfile_template Dockerfile
sed  -i '' "s/APIGEE_USER/$APIGEE_USER/g" Dockerfile
sed  -i '' "s/APIGEE_ORG/$APIGEE_ORG/g" Dockerfile
sed  -i '' "s/APIGEE_PASS/$APIGEE_PASS/g" Dockerfile


gcloud builds submit --tag gcr.io/$GPROJECT/load-test


gcloud compute addresses create load-locust-asia-east1-ip --region asia-east1
gcloud compute addresses create load-locust-asia-northeast1-ip --region asia-northeast1
gcloud compute addresses create load-locust-europe-north1-ip --region europe-north1
gcloud compute addresses create load-locust-europe-west1-ip --region europe-west1
gcloud compute addresses create load-locust-us-central1-ip --region us-central1
gcloud compute addresses create load-locust-us-east1-ip --region us-east1
gcloud compute addresses create load-locust-us-east4-ip --region us-east4
gcloud compute addresses create load-locust-us-west1-ip --region us-west1
gcloud compute addresses create load-locust-europe-west4-ip --region europe-west4

sleep 60

ADDR=$(gcloud compute addresses describe load-locust-asia-east1-ip --region asia-east1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-asia-east1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone asia-east1-b 
ADDR=$(gcloud compute addresses describe load-locust-asia-northeast1-ip --region asia-northeast1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-asia-northeast1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone asia-northeast1-b
ADDR=$(gcloud compute addresses describe load-locust-europe-north1-ip --region europe-north1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-europe-north1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone europe-north1-b
ADDR=$(gcloud compute addresses describe load-locust-europe-west1-ip --region europe-west1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-europe-west1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone europe-west1-b 
ADDR=$(gcloud compute addresses describe load-locust-us-central1-ip --region us-central1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-us-central1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-central1-b 
ADDR=$(gcloud compute addresses describe load-locust-us-east1-ip --region us-east1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-us-east1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-east1-b
ADDR=$(gcloud compute addresses describe load-locust-us-east4-ip --region us-east4 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-us-east4 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-east4-b
ADDR=$(gcloud compute addresses describe load-locust-us-west1-ip --region us-west1 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-us-west1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone us-west1-b
ADDR=$(gcloud compute addresses describe load-locust-europe-west4-ip --region europe-west4 --format json | jq -r '.address')
gcloud compute instances create-with-container load-locust-europe-west4 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --address $ADDR --zone europe-west4-b 
