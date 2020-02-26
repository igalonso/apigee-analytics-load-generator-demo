USR=$1
PASS=$2
TOKEN=$(echo "$USR:$PASS\c" | base64)
APIGEE_ORG=$3
APIGEE_ENV=$4

APPS=$(curl -X GET --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apps?status=approved")
DEVS=$(curl -X GET --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers")
PRODS=$(curl -X GET --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apiproducts")



for dev in $(echo "${DEVS}" | jq -r '.[]'); do
    echo ${dev}
    DEVS_APPS=$(curl -X GET --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}/apps")
    echo $DEVS_APPS
    for app in $(echo "${DEVS_APPS}" | jq -r '.[]'); do
        echo "----------Deleting apps"
        curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}/apps/${app}"
    done
    curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/developers/${dev}"
done

for product in $(echo "${PRODS}" | jq -r '.[]'); do
    echo "----------Deleting products"
    curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apiproducts/${product}"
done
echo "----------Deleting load-locust instances"
gcloud compute instances delete load-locust-asia-east1 --zone asia-east1-b --quiet
gcloud compute instances delete load-locust-asia-northeast1 --zone asia-northeast1-b --quiet
gcloud compute instances delete load-locust-europe-north1 --zone europe-north1-b --quiet
gcloud compute instances delete load-locust-europe-west1 --zone europe-west1-b --quiet
gcloud compute instances delete load-locust-us-central1 --zone us-central1-b --quiet
gcloud compute instances delete load-locust-us-east1 --zone us-east1-b  --quiet
gcloud compute instances delete load-locust-us-east4  --zone us-east4-b --quiet
gcloud compute instances delete load-locust-us-west1  --zone us-west1-b --quiet
gcloud compute instances delete load-locust-europe-west4 --zone europe-west4-b --quiet

echo "----------Deleting revision proxies"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Catalog/revisions/1/deployments"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Users/revisions/1/deployments"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Recommendation/revisions/1/deployments"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Loyalty/revisions/1/deployments"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/environments/$APIGEE_ENV/apis/Load-Generator-Checkout/revisions/1/deployments"

echo "----------Deleting proxies"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Catalog"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Users"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Recommendation"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Loyalty"
curl -X DELETE --header "Authorization: Basic $TOKEN" "https://api.enterprise.apigee.com/v1/organizations/$APIGEE_ORG/apis/Load-Generator-Checkout"