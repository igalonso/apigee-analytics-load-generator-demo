# v2
To launch it, execute:
```
export GCLOUDTOKEN=$(gcloud auth print-access-token)
sh init.sh ACTION $GCLOUDTOKEN APIGEE_ORG APIGEE_ENV GPROJECT_APIGEE GPROJECT_GCP APPENGINE APIGEE_URL APPENGINE_DOMAIN_NAME GCP_SVC_ACCOUNT_EMAIL UUID
```

* **ACTION**: ```launch``` to start the load generator or ```delete``` to remove the load generator

* **APIGEE_USER**: Apigee User with organization administrator permissions

* **APIGEE_PASS**: Apigee password that matches previous user

* **APIGEE_ORG**: Apigee Organization to deploy to.

* **APÎGEE_ENV**: Apigee Environment to use under previous organization.

* **GPROJECT_APIGEE**: Google Cloud Project ID where Apigee X or Hybrid resides.

* **GPROJECT_GCP**: Google Cloud Project ID where the VMs will be deployed to.

* **APPENGINE**: Google Cloud App Engine app name that will be used.

* **APIGEE_URL**: Apigee URL for the specific environment group.

* **APPENGINE_DOMAIN_NAME**: Domain name for your backends.

* **GCP_SVC_ACCOUNT_EMAIL**: Service account email used for the deployment of VMs.

* **UUID**: Random number that you will need to remember (to support multiple instances of this demo within the same org) in order to delete this deployment afterwards..