FROM google/cloud-sdk:slim
COPY load-generator /load-generator
COPY load-generator-key.json load-generator-key.json
ARG APIGEE_USER
ARG APIGEE_PASS
ARG APIGEE_ORG
ARG APIGEE_ENV
ARG GPROJECT
ARG APPENGINE
ARG APIGEE_URL
ARG APPENGINE_DOMAIN_NAME
ARG GCP_SVC_ACCOUNT_EMAIL
ARG RAND

RUN apt update && apt-get install -y \ 
    maven jq
CMD cd load-generator && \
    sh initial.sh ${APIGEE_USER} ${APIGEE_PASS} ${APIGEE_ORG} ${APIGEE_ENV} ${GPROJECT} ${APPENGINE} ${APIGEE_URL} ${APPENGINE_DOMAIN_NAME} ${GCP_SVC_ACCOUNT_EMAIL} ${RAND}