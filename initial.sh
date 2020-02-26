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

cat Dockerfile
gcloud builds submit --tag gcr.io/$GPROJECT/load-test

gcloud compute instances create-with-container load-locust-asia-east1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone asia-east1-b 
gcloud compute instances create-with-container load-locust-asia-northeast1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone asia-northeast1-b
gcloud compute instances create-with-container load-locust-europe-north1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone europe-north1-b 
gcloud compute instances create-with-container load-locust-europe-west1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone europe-west1-b 
gcloud compute instances create-with-container load-locust-us-central1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone us-central1-b 
gcloud compute instances create-with-container load-locust-us-east1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone us-east1-b 
gcloud compute instances create-with-container load-locust-us-east4 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone us-east4-b
gcloud compute instances create-with-container load-locust-us-west1 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone us-west1-b 
gcloud compute instances create-with-container load-locust-europe-west4 --machine-type=f1-micro --container-image gcr.io/$GPROJECT/load-test --zone europe-west4-b 