USR=$1
PASS=$2
TOKEN=$(echo "$USR:$PASS\c" | base64)
APIGEE_ORG=$3
APIGEE_ENV=$4
RAND=$5

declare -a arr=("hugh@startkaleo.com" "grant@enterprise.com" "petsell@wrong.com" "tomjones@enterprise.com" "joew@bringiton.com" "acop@enterprise.com" "barbg@enterprise.com" "dandee@enterprise.com" "freds@bringiton.com")


for dev in ${arr[@]}; do
    echo "Developer: "$dev
    DEVS_APPS=$(curl --silent -X GET --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/$dev/apps") > /dev/null
    echo "Has these Apps: "$DEVS_APPS
    echo "----------Deleting apps"
    for app in $(echo "${DEVS_APPS}" | jq -r '.[]'); do
        curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}/apps/${app}" > /dev/null
    done
    curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}" > /dev/null
done

declare -a prods=("Load-Generator-Product-Store" "Load-Generator-Product-Shopping" "Load-Generator-Product-Catalog" "Load-Generator-Product-Consumer" "Load-Generator-Product-Admin")

echo "----------Deleting products"
for product in ${prods[@]}; do  
    curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apiproducts/${product}" > /dev/null
done
echo "----------Deleting load-locust instances"
gcloud compute instances delete $(echo "load-locust-asia-east1-"$RAND) --zone asia-east1-b --quiet &
gcloud compute instances delete $(echo "load-locust-asia-northeast1-"$RAND) --zone asia-northeast1-b --quiet &
gcloud compute instances delete $(echo "load-locust-europe-north1-"$RAND) --zone europe-north1-b --quiet &
gcloud compute instances delete $(echo "load-locust-europe-west1-"$RAND) --zone europe-west1-b --quiet &
gcloud compute instances delete $(echo "load-locust-us-central1-"$RAND) --zone us-central1-b --quiet &
gcloud compute instances delete $(echo "load-locust-us-east1-"$RAND) --zone us-east1-b  --quiet &
gcloud compute instances delete $(echo "load-locust-us-east4-"$RAND)  --zone us-east4-b --quiet &
gcloud compute instances delete $(echo "load-locust-us-west1-"$RAND)  --zone us-west1-b --quiet &
gcloud compute instances delete $(echo "load-locust-europe-west4-"$RAND) --zone europe-west4-b --quiet

gcloud compute addresses delete $(echo "load-locust-asia-east1-ip-"$RAND)  --region asia-east1 --quiet
gcloud compute addresses delete $(echo "load-locust-asia-northeast1-ip-"$RAND)  --region asia-northeast1 --quiet
gcloud compute addresses delete $(echo "load-locust-europe-north1-ip-"$RAND)  --region europe-north1 --quiet
gcloud compute addresses delete $(echo "load-locust-europe-west1-ip-"$RAND)  --region europe-west1 --quiet
gcloud compute addresses delete $(echo "load-locust-us-central1-ip-"$RAND)  --region us-central1 --quiet
gcloud compute addresses delete $(echo "load-locust-us-east1-ip-"$RAND)  --region us-east1 --quiet
gcloud compute addresses delete $(echo "load-locust-us-east4-ip-"$RAND)  --region us-east4 --quiet
gcloud compute addresses delete $(echo "load-locust-us-west1-ip-"$RAND)  --region us-west1 --quiet
gcloud compute addresses delete $(echo "load-locust-europe-west4-ip-"$RAND)  --region europe-west4 --quiet


echo "----------Deleting revision proxies"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Catalog/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Users/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Recommendation/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Loyalty/revisions/1/deployments"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Checkout/revisions/1/deployments"

echo "----------Deleting proxies"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Catalog"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Users"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Recommendation"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Loyalty"
curl --silent -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Checkout"
