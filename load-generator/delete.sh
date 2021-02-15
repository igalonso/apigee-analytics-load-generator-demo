#!/bin/bash
# . delete-all.sh <APIGEE_USER> <APIGEE_PASS> <APIGEE_ORG> <APIGEE_ENV> <UUID>
#${APIGEE_USER} ${APIGEE_PASS} ${APIGEE_ORG} ${APIGEE_ENV} ${GPROJECT} ${APPENGINE} ${APIGEE_URL} ${APPENGINE_DOMAIN_NAME} ${GCP_SVC_ACCOUNT_EMAIL} ${RAND}
GCLOUD_TOKEN=$1
APIGEE_ORG=$2
APIGEE_ENV=$3
GPROJECT=$4
APPENGINE=$5
APIGEE_URL=$6
APPENGINE_DOMAIN_NAME=$7
GCP_SVC_ACCOUNT_EMAIL=$8
RAND=$9


gcloud auth activate-service-account \
        $GCP_SVC_ACCOUNT_EMAIL \
        --key-file=../load-generator-key.json --project=$GPROJECT

arr=("hugh@startkaleo.com" "grant@enterprise.com" "petsell@wrong.com" "tomjones@enterprise.com" "joew@bringiton.com" "acop@enterprise.com" "barbg@enterprise.com" "dandee@enterprise.com" "freds@bringiton.com")


# for dev in ${arr[@]}; do
#     echo "Developer: "$dev
#     DEVS_APPS=$(curl --silent -X GET --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/$dev/apps") > /dev/null
#     echo "Has these Apps: "$DEVS_APPS
#     echo "----------Deleting apps"
#     for app in $(echo $DEVS_APPS | jq -r '.[]'); do
#         curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}/apps/${app}" > /dev/null
#     done
#     curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}" > /dev/null
# done

# declare -a prods=("Load-Generator-Product-Store" "Load-Generator-Product-Shopping" "Load-Generator-Product-Catalog" "Load-Generator-Product-Consumer" "Load-Generator-Product-Admin")

# echo "----------Deleting products"
# for product in ${prods[@]}; do  
#     curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apiproducts/${product}" > /dev/null
# done
echo "----------Deleting load-locust instances"
gcloud compute instances delete $(echo "load-locust-asia-east1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-asia-northeast1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-europe-north1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-europe-west1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-us-central1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-us-east1-"$RAND) --zone europe-west2-b  --quiet &
gcloud compute instances delete $(echo "load-locust-us-east4-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-us-west1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "load-locust-europe-west4-"$RAND) --zone europe-west2-b --quiet

gcloud compute addresses delete $(echo "load-locust-asia-east1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-asia-northeast1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-europe-north1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-europe-west1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-us-central1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-us-east1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-us-east4-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-us-west1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "load-locust-europe-west4-ip-"$RAND) --region europe-west2 --quiet


# echo "----------Deleting revision proxies"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Catalog/revisions/1/deployments"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Users/revisions/1/deployments"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Recommendation/revisions/1/deployments"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Loyalty/revisions/1/deployments"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Checkout/revisions/1/deployments"

# echo "----------Deleting proxies"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Catalog"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Users"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Recommendation"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Loyalty"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Checkout"

# echo "----------Deleting Target Servers"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/targetservers/Load-Generator-Catalog-Target"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/targetservers/Load-Generator-Checkout-Target"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/targetservers/Load-Generator-Loyalty-Target"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/targetservers/Load-Generator-Recommendation-Target"
# curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/targetservers/Load-Generator-Users-Target"
