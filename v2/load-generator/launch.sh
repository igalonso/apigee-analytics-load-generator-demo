#!/bin/bash
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
WORKLOAD_LEVEL=${11}
DEPLOYMENT=${12}

echo "Authorizing"
gcloud auth activate-service-account \
        $GCP_SVC_ACCOUNT_EMAIL \
        --key-file=../load-generator-key.json --project=$GPROJECT_GCP
echo "End authorizing"
folder=$PWD
if [ $DEPLOYMENT == "all" ] || [ $DEPLOYMENT == "apigee" ]; then
        #Deploy target servers
        cd $folder
        gcloud config set project $GPROJECT_APIGEE
        echo "---->DEPLOYING Target Servers<-------"
        cd config
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
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN -Dapigee.config.options=create

        #Deploying proxies
        echo "---->DEPLOYING PROXIES<-------"
        cd $folder
        cd proxies
        cp shared-pom.xml.template shared-pom.xml
        sed -i "s/<environment>/$APIGEE_ENV/g" shared-pom.xml
        echo $PWD
        cd Load-Generator-Catalog
        sed -i "s/<environment>/$APIGEE_ENV/g" shared-pom.xml
        cp config.json.template config.json
        sed -i "s/<environment>/$APIGEE_ENV/g" config.json
        sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
        cd ../Load-Generator-Checkout
        cp config.json.template config.json
        sed -i "s/<environment>/$APIGEE_ENV/g" config.json
        sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
        cd ../Load-Generator-Loyalty
        cp config.json.template config.json
        sed -i "s/<environment>/$APIGEE_ENV/g" config.json
        sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
        cd ../Load-Generator-Recommendation
        cp config.json.template config.json
        sed -i "s/<environment>/$APIGEE_ENV/g" config.json
        sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN
        cd ../Load-Generator-User
        cp config.json.template config.json
        sed -i "s/<environment>/$APIGEE_ENV/g" config.json
        sed -i "s/<gproject>/$GPROJECT_APIGEE/g" config.json
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN


        #Deploy products
        echo "---->DEPLOYING PRODUCTS, DEVELOPERS AND APPS<-------"
        cd $folder
        cd config
        echo $PWD
        sed -i "s/<domain>/$APPENGINE_DOMAIN_NAME/g" edge.json
        sed -i "s/<environment>/$APIGEE_ENV/g" edge.json
        mvn install -P$APIGEE_ENV -Dorg=$APIGEE_ORG -Denv=$APIGEE_ENV -Dbearer=$GCLOUD_APIGEE_TOKEN -Dapigee.config.options=create
fi
if [ $DEPLOYMENT == "all" ] || [ $DEPLOYMENT == "gcp" ]; then
        #Building docker image
        cd $folder
        cd consumers
        cp Dockerfile_template Dockerfile
        sed -i "s/GCP_TOKEN/$GCLOUD_APIGEE_TOKEN/g" Dockerfile
        sed -i "s/APIGEE_ORG/$APIGEE_ORG/g" Dockerfile
        sed -i "s/APIGEE_ENV/$APIGEE_ENV/g" Dockerfile
        sed -i "s/HOST/$APIGEE_URL/g" Dockerfile
        sed -i "s/WORKLOAD_LEVEL/$WORKLOAD_LEVEL/g" Dockerfile

        # Deploying Locust instances
        gcloud config set project $GPROJECT_GCP
        gcloud services enable cloudbuild.googleapis.com compute.googleapis.com storage.googleapis.com storage-api.googleapis.com   
        gcloud builds submit --tag gcr.io/$GPROJECT_GCP/load-test
        gcloud compute addresses create $(echo "v2-1-load-locust-ip-"$RAND) --region europe-west2
        ADDR=$(gcloud compute addresses describe v2-1-load-locust-ip-$(echo $RAND) --region europe-west2 --format json | jq -r '.address')
        gcloud compute instances create-with-container $(echo "v2-1-load-locust-"$RAND) --machine-type=e2-standard-2 --container-image gcr.io/$GPROJECT_GCP/load-test --address $ADDR --zone europe-west2-b 
fi




