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

gcloud config set project $GPROJECT_GCP
gcloud auth activate-service-account \
        $GCP_SVC_ACCOUNT_EMAIL \
        --key-file=../load-generator-key.json --project=$GPROJECT_GCP
#Deleting GCP Stuff
echo "----------Deleting v2-load-locust instances"
gcloud compute instances delete $(echo "v2-load-locust-asia-east1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-asia-northeast1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-europe-north1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-europe-west1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-us-central1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-us-east1-"$RAND) --zone europe-west2-b  --quiet &
gcloud compute instances delete $(echo "v2-load-locust-us-east4-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-us-west1-"$RAND) --zone europe-west2-b --quiet &
gcloud compute instances delete $(echo "v2-load-locust-europe-west4-"$RAND) --zone europe-west2-b --quiet

gcloud compute addresses delete $(echo "v2-load-locust-asia-east1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-asia-northeast1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-europe-north1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-europe-west1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-us-central1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-us-east1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-us-east4-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-us-west1-ip-"$RAND) --region europe-west2 --quiet
gcloud compute addresses delete $(echo "v2-load-locust-europe-west4-ip-"$RAND) --region europe-west2 --quiet


# DELETING APIGEE's STUFF
gcloud config set project $GPROJECT_APIGEE
export APIGEE_MNGMT_URL="https://apigee.googleapis.com/v1/organizations/$APIGEE_ORG"

arr=("hugh@startkaleo.com" "grant@enterprise.com" "petsell@wrong.com" "tomjones@enterprise.com" "joew@bringiton.com" "acop@enterprise.com" "barbg@enterprise.com" "dandee@enterprise.com" "freds@bringiton.com")

for dev in ${arr[@]}; do
    echo "Developer: "$dev
    DEVS_APPS=$(curl --silent -X GET --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/developers/$dev/apps") > /dev/null
    echo "----------Deleting apps"
    for app in $(echo $DEVS_APPS | jq -r .app[0].appId); do
        echo "Deleting app: $app"
        curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/developers/$dev/apps/${app}" > /dev/null
    done
    echo "Deleting developer: $dev"
    curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/developers/$dev" > /dev/null
done

declare -a prods=("Load-Generator-Product-Store" "Load-Generator-Product-Shopping" "Load-Generator-Product-Catalog" "Load-Generator-Product-Consumer" "Load-Generator-Product-Admin")

echo "----------Deleting products"
for product in ${prods[@]}; do  
    echo "Deleting Product: $product"
    curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apiproducts/${product}"  > /dev/null
done


echo "----------Deleting deployments"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/apis/Load-Generator-Catalog/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/apis/Load-Generator-Users/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/apis/Load-Generator-Recommendation/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/apis/Load-Generator-Loyalty/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/apis/Load-Generator-Checkout/revisions/1/deployments"
echo "----------Deleting revision proxies"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Catalog/revisions/1"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Recommendation/revisions/1"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Users/revisions/1"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Loyalty/revisions/1"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Checkout/revisions/1"


echo "----------Deleting proxies"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Catalog"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Users"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Recommendation"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Loyalty"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/apis/Load-Generator-Checkout"

echo "----------Deleting Target Servers"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/targetservers/Load-Generator-Catalog-Target"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/targetservers/Load-Generator-Checkout-Target"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/targetservers/Load-Generator-Loyalty-Target"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/targetservers/Load-Generator-Recommendation-Target"
curl --silent -X DELETE --header "Authorization: Bearer $GCLOUD_APIGEE_TOKEN" "$APIGEE_MNGMT_URL/environments/$APIGEE_ENV/targetservers/Load-Generator-Users-Target"
