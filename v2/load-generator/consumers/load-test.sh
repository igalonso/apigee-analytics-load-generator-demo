GCP_TOKEN=$1
APIGEE_ORG=$2
APIGEE_ENV=$3
HOST=$4
WORKLOAD_LEVEL=$5
if [ $WORKLOAD_LEVEL = "high" ]; then
    concurrent=15
    requests=20
fi
if [ $WORKLOAD_LEVEL = "medium" ]; then
    concurrent=8
    requests=10
fi
if [ $WORKLOAD_LEVEL = "low" ]; then
    concurrent=1
    requests=5
fi
if [ $WORKLOAD_LEVEL = "test" ]; then
    concurrent=1
    requests=1
fi

echo "Requests: "+ $requests
echo $concurrent
env TOKEN=$GCP_TOKEN APIGEE_ORG=$APIGEE_ORG APIGEE_ENV=$APIGEE_ENV locust --host=https://$HOST/v1 --headless -u $concurrent -r $requests -f locust-load.py