FROM google/cloud-sdk:slim
COPY load-generator /load-generator
COPY load-generator-key.json load-generator-key.json
ARG ACTION 
ARG GCLOUD_APIGEE_TOKEN
ARG APIGEE_ORG
ARG APIGEE_ENV
ARG GPROJECT_APIGEE
ARG GPROJECT_GCP
ARG APPENGINE
ARG APIGEE_URL
ARG APPENGINE_DOMAIN_NAME
ARG GCP_SVC_ACCOUNT_EMAIL
ARG RAND

RUN apt update && apt-get install -y \ 
    maven jq
CMD echo ${RAND} && \
    cd load-generator && \
    chmod 777 delete.sh && \
    chmod 777 launch.sh && \
    ./${ACTION}.sh ${GCLOUD_APIGEE_TOKEN} ${APIGEE_ORG} ${APIGEE_ENV} ${GPROJECT_APIGEE} ${GPROJECT_GCP} ${APPENGINE} ${APIGEE_URL} ${APPENGINE_DOMAIN_NAME} ${GCP_SVC_ACCOUNT_EMAIL} ${RAND}